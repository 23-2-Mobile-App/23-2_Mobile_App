import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<List<Record>> getRecords() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection('users').doc(currentUser?.uid)
          .collection('records').orderBy('date', descending: true).get();
      List<Record> records = querySnapshot.docs.map((doc) => Record.fromFirestore(doc)).toList();
      print("fetching records");
      return records;
    } catch (e) {
      print('Error fetching records: $e');
      return [];
    }

  }

  Future<void> createRecord({
    required Timestamp date,
    required double distance,
    required double pace,
    required double time,
  }) async {
    try {

      User? user = FirebaseAuth.instance.currentUser;

      DocumentReference documentReference = await _firestore.collection('users').doc(user?.uid)
          .collection('records').add({
        'date': date,
        'distance': distance,
        'pace': pace,
        'time': time,
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