import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'record.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RecordProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<List<Record>> getRecords() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection('users').doc(currentUser?.uid)
          .collection('records').orderBy('date', descending: true).get();
      List<Record> records = querySnapshot.docs.map((doc) => Record.fromFirestore(doc)).toList();
      print("ss");
      return records;
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }

  }

  Future<void> saveRecord({
    required String uid,
    required String date,
    required int distance,
    required int pace,
    required Timestamp time,
    required String imgURL,
  }) async {
    try {

      User? user = FirebaseAuth.instance.currentUser;

      DocumentReference documentReference = await _firestore.collection('user').doc(currentUser?.uid)
          .collection('records').add({
        'distance': distance,
        'pace': pace,
        'time': time,
        'imgURL': 0,
        'date': FieldValue.serverTimestamp(),
      });


      // Get the document ID and update the product
      String documentId = documentReference.id;
      await _firestore.collection('users').doc(currentUser?.uid)
          .collection('records').doc(documentId).update({
        'uid': documentId,
      });

      notifyListeners();
    } catch (e) {
      print('Error saving product: $e');
      throw e;
    }
  }


  Future<void> deleteRecord(String recordID) async {
    try {
      await _firestore.collection('users').doc(currentUser?.uid)
          .collection('records').doc(recordID).delete();
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
      // Handle the error as needed
    }
  }
}