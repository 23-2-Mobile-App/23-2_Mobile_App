// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'users.dart';
//
// class UserProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   List<User> _wishlistProducts = [];
//   List<User> get wishlistProducts => _wishlistProducts;
//
//   Future<List<User>> loadRecords() async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> recordSnapshot = await _firestore
//           .collection('users')
//           .doc(currentUser?.uid)
//           .collection('records')
//           .get();
//
//       List<String> productIds = recordSnapshot.docs.map((doc) => doc.id).toList();
//
//       List<Product> wishlistProducts = [];
//
//       for (String productId in productIds) {
//         DocumentSnapshot<Map<String, dynamic>> productSnapshot = await _firestore
//             .collection('users')
//             .doc(productId)
//             .get();
//
//         if (productSnapshot.exists) {
//           Product product = Product.fromFirestore(productSnapshot);
//           wishlistProducts.add(product);
//         }
//       }
//
//
//       return wishlistProducts;
//     } catch (e) {
//       print('Error loading wishlist products: $e');
//       throw e;
//     }
//   }
// }
