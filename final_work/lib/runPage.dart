import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RunPage extends StatefulWidget {
  const RunPage({Key? key}) : super(key: key);

  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  double distance = 0.0; // 이동 거리 (미터)
  double speed = 0.0;    // 현재 속도 (m/s)
  double avgSpeed = 0.0; // 평균 속도 (m/s)
  Position? _previousLocation;
  late Timer _timer;
  double elapsedTime = 0.0; // 경과 시간 (초)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime += 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF01C1FD),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                      text: "${(distance / 1000).toStringAsFixed(2)}",
                    ),
                    TextSpan(
                      text: " km",
                      style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 100,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: "${speed.toStringAsFixed(2)}",
                        ),
                        TextSpan(
                          text: " m/s",
                          style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "${_formatTime(elapsedTime)}",
                    style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                      children: [
                        TextSpan(
                          text: "0",
                        ),
                        TextSpan(
                          text: " kcal",
                          style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 70,),
                  Text(
                    "- -",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black,fontStyle: FontStyle.italic),
                  ),
                ],
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  // Cancel the timer when stopping running
                  _timer.cancel();
                  // Navigate back to the previous screen
                  Navigator.pushNamed(context,'/pausePage');
                },
                child: Text('Stop Running'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(double seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (seconds % 60).floor();
    return '$minutes:$remainingSeconds';
  }



  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_previousLocation != null) {
        double currentDistance = Geolocator.distanceBetween(
          _previousLocation!.latitude,
          _previousLocation!.longitude,
          position.latitude,
          position.longitude,
        );

        setState(() {
          distance += currentDistance;
        });

        if (position.speed != null) {
          setState(() {
            avgSpeed = distance / (position.timestamp!.difference(_previousLocation!.timestamp!).inSeconds);
          });
        }

        setState(() {
          speed = position.speed ?? 0.0;
        });
      }

      setState(() {
        _previousLocation = position;
      });

      // Schedule the next location update
      Future.delayed(Duration(seconds: 1), _getCurrentLocation);
    } catch (e) {
      print("Error: $e");
    }
  }
}