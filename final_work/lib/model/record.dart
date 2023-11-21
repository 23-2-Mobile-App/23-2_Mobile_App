import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  late Timestamp date;
  late double distance;
  late double pace;
  late double time;
  late String imgURL;

  Record({
    required this.date,
    required this.distance,
    required this.pace,
    required this.time,
    required this.imgURL,
  });


  factory Record.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp dateTimestamp = data['date'] as Timestamp;
    DateTime dateTime = dateTimestamp.toDate();
    return Record(
      date: dateTimestamp,
      distance: data['distance'] ?? 0,
      pace: data['pace'] ?? 0,
      time: data['time'] ?? 0,
      imgURL: '0',
    );
  }
}

