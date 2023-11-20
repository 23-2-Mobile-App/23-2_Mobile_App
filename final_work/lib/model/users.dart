import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String uid;
  late String email;
  late int sum_distance;
  late int sum_time;
  late String user_RC;
  late String user_image;
  late String user_name;
  late int total_run;

  Users({
    required this.uid,
    required this.email,
    required this.sum_distance,
    required this.sum_time,
    required this.user_RC,
    required this.user_image,
    required this.user_name,
    required this.total_run,
  });


  factory Users.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print(data['modified_user_name'] );
    return Users(
      uid: doc.id,
      email: data['email'] ?? '',
      sum_distance: data['sum_distance'] ?? '',
      sum_time: data['sum_time'] ?? '',
      user_RC: data['user_RC'] ?? '',
      user_image: data['user_image'] ?? 0,
      user_name: data['user_name'] ?? '',
      total_run: data['total_run'] ?? '',
    );
  }


}

