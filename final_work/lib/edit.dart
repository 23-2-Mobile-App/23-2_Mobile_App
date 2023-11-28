// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'model/users.dart';
//
// class EditPage extends StatefulWidget {
//   const EditPage({Key? key}) : super(key: key);
//
//   @override
//   State<EditPage> createState() => _EditPageState();
// }
//
// class _EditPageState extends State<EditPage> {
//   late TextEditingController _productNameController = TextEditingController();
//   late TextEditingController _priceController = TextEditingController();
//   late TextEditingController _descriptionController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   XFile? _image;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _getImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = XFile(pickedFile.path);
//       });
//     }
//   }
//
//   Future<String> _uploadImage(XFile imageFile) async {
//     try {
//       String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       Reference storageReference = _storage.ref().child('/$fileName');
//
//       // Convert XFile to File
//       File file = File(imageFile.path);
//
//       // Upload the File to Firebase Storage
//       await storageReference.putFile(file);
//
//       // Get the download URL
//       String downloadUrl = await storageReference.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       throw e;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     User product = ModalRoute.of(context)!.settings.arguments as Product;
//
//     Future<void> _updateProduct(Product product) async {
//       try {
//         // Get the current values or use the existing ones if the corresponding text fields are empty
//         String updatedName = _productNameController.text.isNotEmpty ? _productNameController.text : product.name;
//         String updatedDescription = _descriptionController.text.isNotEmpty ? _descriptionController.text : product.description;
//         int updatedPrice = _priceController.text.isNotEmpty ? int.tryParse(_priceController.text) ?? 0 : int.tryParse(product.price as String) ?? 0;
//         String updatedImageUrl = product.imgUrl;
//
//         // If a new image is selected, upload it to Firebase Storage and get the URL
//         if (_image != null) {
//           updatedImageUrl = await _uploadImage(_image!);
//           print('Image uploaded successfully. URL: $updatedImageUrl');
//         }
//
//         // Prepare the data to be updated
//         Map<String, dynamic> updatedData = {
//           'name': updatedName,
//           'description': updatedDescription,
//           'price': updatedPrice,
//           'modified_date': FieldValue.serverTimestamp(),
//           'imgUrl': updatedImageUrl,
//         };
//
//         await _firestore.collection('product').doc(product.id).update(updatedData);
//
//         print("Successfully Updated");
//       } catch (error) {
//         print('Error updating product: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to update product'),
//           ),
//         );
//       }
//     }
//
//
//     return MaterialApp(
//       title: 'Flutter layout demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Edit"),
//               SizedBox(width: 8.0),
//               TextButton(
//                 onPressed: () async {
//                   _updateProduct(product);
//                   await Future.delayed(Duration(seconds: 4));
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                   Navigator.pushNamed(context, '/');
//                 },
//                 child: Text(
//                   'Save',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//           leading: IconButton(
//             icon: Icon(Icons.cancel),
//             onPressed: () {
//               Navigator.of(context).pop(); // 뒤로 가기 기능 추가
//             },
//           ),
//         ),
//         body: ListView(
//           children: [
//             if (_image == null) Image.network(product.imgUrl),
//             if (_image != null) _buildPhotoArea(),
//             Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.photo_camera),
//                       onPressed: () {
//                         _getImage();
//                       },
//                     ),
//                     SizedBox(height: 8.0),
//                     TextField(
//                       controller: _productNameController,
//                       decoration: InputDecoration(
//                         labelText: '${product.name}',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     TextField(
//                       controller: _descriptionController,
//                       decoration: InputDecoration(
//                         labelText: '${product.description}',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     TextField(
//                       controller: _priceController,
//                       decoration: InputDecoration(
//                         labelText: '${product.price}',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     // Other TextFields for additional properties if needed
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPhotoArea() {
//     return _image != null
//         ? Container(
//       width: 300,
//       height: 300,
//       child: Image.file(File(_image!.path)),
//     )
//         : Container(
//       width: 300,
//       height: 300,
//       color: Colors.grey,
//     );
//   }
//
// }
