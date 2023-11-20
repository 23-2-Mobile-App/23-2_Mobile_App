// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import 'model/model_record.dart';
//
//
// class AddPage extends StatefulWidget {
//   const AddPage({Key? key}) : super(key: key);
//
//   @override
//   _AddPageState createState() => _AddPageState();
// }
//
// class _AddPageState extends State<AddPage> {
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   XFile? _image ;
//   late String URL;
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//
//   Future<void> saveProduct(
//       String image,
//       String productName,
//       int price,
//       String description,
//       ) async {
//     try {
//
//       User? user = FirebaseAuth.instance.currentUser;
//
//       // Call the saveProduct method from ProductProvider
//       await ProductProvider().saveProduct(
//         productName: productName,
//         price: price,
//         description: description,
//         imgUrl: image,
//         userId: user!.uid,
//       );
//     } catch (e) {
//       print('Error saving product: $e');
//       throw e;
//     }
//   }
//
//
//   Future<String> _uploadImage(XFile imageFile) async {
//     try {
//       String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       Reference storageReference = _storage.ref().child('/$fileName');
//
//       File file = File(imageFile.path);
//       await storageReference.putFile(file);
//
//       String downloadUrl = await storageReference.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       throw e;
//     }
//   }
//
//
//
//   @override
//   void _getImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = XFile(pickedFile.path);
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add'),
//         leading: IconButton(
//           icon: Icon(Icons.cancel),
//           onPressed: () {
//             Navigator.of(context).pop(); // 뒤로 가기 기능 추가
//           },
//         ),
//         actions: <Widget>[
//           Row(
//             children: [
//               TextButton(
//                 onPressed: ()  async {
//                   if(_image != null){
//                     URL = await _uploadImage(_image!);
//                   }
//                   else{
//                     URL = 'https://firebasestorage.googleapis.com/v0/b/finalproject-9bf19.appspot.com/o/default%2Flogo.png?alt=media&token=c2e8ed74-6c8a-4417-9078-c4e896458f6c';
//                   }
//                   saveProduct(URL,_productNameController.text,int.parse(_priceController.text) as int,_descriptionController.text);
//                   await Future.delayed(Duration(seconds: 2));
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/');
//
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           Column(
//             children: [
//               Container(
//                   height: 200,
//                   color: Colors.grey[200], // 회색 박스
//                   child: _buildPhotoArea()
//               ),
//               IconButton(
//                 icon: Icon(Icons.photo_camera),
//                 onPressed: () {
//                   _getImage();
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: _productNameController,
//                   decoration: InputDecoration(
//                     labelText: 'Product Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: _priceController,
//                   decoration: InputDecoration(
//                     labelText: 'Price',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: _descriptionController,
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildPhotoArea() {
//     return _image != null
//         ? Container(
//       width: 300,
//       height: 300,
//       child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
//     )
//         :Image.network('https://handong.edu/site/handong/res/img/logo.png');
//   }
// }
//
