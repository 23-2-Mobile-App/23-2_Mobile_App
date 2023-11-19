import 'dart:async';
import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  int count = 5;
  late Timer timer;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 200,),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("save")),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}