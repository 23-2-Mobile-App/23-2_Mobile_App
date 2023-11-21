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
//
//   // Future<bool> isItemInWishlist(String itemId, String userId) async {
//   //   try {
//   //     // itemId와 userId가 비어 있거나 null이면 false를 반환
//   //     if (itemId == null || itemId.isEmpty || userId == null || userId.isEmpty) {
//   //       print('Item ID 또는 User ID가 유효하지 않습니다.');
//   //       return false;
//   //     }
//   //
//   //     DocumentSnapshot<Map<String, dynamic>> wishlistDocument = await _firestore
//   //         .collection('users')
//   //         .doc(userId)
//   //         .collection('wish_list')
//   //         .doc(itemId)
//   //         .get();
//   //     return wishlistDocument.exists;
//   //   } catch (e) {
//   //     print('Error checking if item is in wishlist: $e');
//   //     throw e;
//   //   }
//   // }
//
// }