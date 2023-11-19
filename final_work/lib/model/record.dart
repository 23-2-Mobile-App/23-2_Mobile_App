import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  late String uid;
  late String date;
  late int distance;
  late int pace;
  late String time;
  late String imgURL;

  Record({
    required this.uid,
    required this.date,
    required this.distance,
    required this.pace,
    required this.time,
    required this.imgURL,
  });


  factory Record.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Record(
      uid: doc.id,
      date: data['date'] ?? '',
      distance: data['distance'] ?? '',
      pace: data['pace'] ?? '',
      time: data['time'] ?? '',
      imgURL: '',
    );
  }


}

