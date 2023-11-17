import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late String id;
  late String name;
  late int price;
  late String description;
  late String imgUrl;
  late int like;
  late Timestamp date;
  late String uid;
  late Timestamp modified_date;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imgUrl,
    required this.like,
    required this.date,
    required this.uid,
    required this.modified_date,
  });


  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print(data['modified_date'] );
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      description: data['description'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      like: data['like'] ?? 0,
      date: data['date'] ?? '',
      uid: data['uid'] ?? '',
      modified_date: data['modified_date'],
    );
  }


}

