import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  late String uid;
  late String email;
  late double sum_distance;
  late double sum_time;
  late String user_RC;
  late String user_image;
  late String user_name;
  late int total_run;
  late int goal;

  Users({
    required this.uid,
    required this.email,
    required this.sum_distance,
    required this.sum_time,
    required this.user_RC,
    required this.user_image,
    required this.user_name,
    required this.total_run,
    required this.goal,
  });


  factory Users.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print(data['modified_user_name']);
    return Users(
      uid: doc.id,
      email: data['email'] ?? '',
      sum_distance: data['sum_distance'] ?? 0.1,
      sum_time: data['sum_time'] ?? 0.1,
      user_RC: data['user_RC'] ?? 'NA',
      user_image: data['user_image'] ?? '',
      user_name: data['user_name'] ?? '',
      total_run: data['total_run'] ?? 0,
      goal: data['total_run'] ?? 10,
    );
  }
}