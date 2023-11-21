import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model_record.dart';
import 'model/record.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = Provider.of<RecordProvider>(context, listen: false);
    Record record = ModalRoute.of(context)!.settings.arguments as Record;
    return Scaffold(
      backgroundColor: Color(0xFF01C1FD), // 배경 색상 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            ElevatedButton(
              onPressed: () {
                recordProvider.createRecord(distance: record.distance, pace: record.pace, time: record.time, date: record.date, imgURL: record.imgURL);
                Navigator.pop(context);
              },
              child: Text("save"),
            ),
          ],
        ),
      ),
    );
  }
}
