import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'model_product.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Product>> fetchProducts(String sortOrder) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection('product').orderBy('price', descending: sortOrder == 'desc').get();
      List<Product> products = querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      print("ss");
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }

  }

  Future<void> saveProduct({
    required String productName,
    required int price,
    required String description,
    required String imgUrl,
    required String userId,
  }) async {
    try {

      User? user = FirebaseAuth.instance.currentUser;

      DocumentReference documentReference = await _firestore.collection('product').add({
        'name': productName,
        'price': price,
        'description': description,
        'imgUrl': imgUrl,
        'like': 0,
        'date': FieldValue.serverTimestamp(),
        'id': user?.uid,
        'modified_date': FieldValue.serverTimestamp(),
        'uid': user?.uid,
        // 다른 필요한 필드 추가
      });


      // Get the document ID and update the product
      String documentId = documentReference.id;
      await _firestore.collection('product').doc(documentId).update({
        'id': documentId,
      });

      notifyListeners();
    } catch (e) {
      print('Error saving product: $e');
      throw e;
    }
  }


  Future<void> deleteProduct(String productID) async {
    try {
      await _firestore.collection('product').doc(productID).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
      // Handle the error as needed
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      // Verify that the product has a valid document ID
      if (product.id == null) {
        throw Exception('Product document ID is null. Unable to update.');
      }

      await _firestore.collection('product').doc(product.id).update({
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'imgUrl': product.imgUrl,
        'modified_date': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      print('Error updating product: $e');
      // Handle the error as needed
      throw e;
    }

  }
}