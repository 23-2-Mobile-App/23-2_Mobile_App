import 'dart:async';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int count = 5;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (count == 0) {
          timer.cancel();
          Navigator.pop(context);
          Navigator.pushNamed(context,'/runPage');
        } else {
          setState(() {
            count--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF01C1FD), // 배경 색상 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (count != 0)
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 96, // 폰트 크기를 두 배로 설정
                  fontWeight: FontWeight.bold, // 볼드체 설정
                  fontStyle: FontStyle.italic,
                  color: Colors.black, // 폰트 색상 설정
                ),
              ),
            if (count == 0)
              Text(
                'Start',
                style: const TextStyle(
                  fontSize: 36, // 적절한 폰트 크기로 설정
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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