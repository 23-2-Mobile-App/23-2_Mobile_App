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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Run Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Distance: ${distance.toStringAsFixed(2)} meters"),
            Text("Speed: ${speed.toStringAsFixed(2)} m/s"),
            Text("Average Speed: ${avgSpeed.toStringAsFixed(2)} m/s"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Stop Running'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_previousLocation != null) {
        // Calculate distance between previous and current locations
        double currentDistance = Geolocator.distanceBetween(
          _previousLocation!.latitude,
          _previousLocation!.longitude,
          position.latitude,
          position.longitude,
        );

        // Update total distance
        setState(() {
          distance += currentDistance;
        });

        // Update average speed
        if (position.speed != null) {
          setState(() {
            avgSpeed = distance / (position.timestamp!.difference(_previousLocation!.timestamp!).inSeconds);
          });
        }
      }

      // Update current speed
      setState(() {
        speed = position.speed ?? 0.0;
      });

      // Update previous location
      setState(() {
        _previousLocation = position;
      });

      // Schedule the next update
      Future.delayed(Duration(seconds: 1), _getCurrentLocation);
    } catch (e) {
      print("Error: $e");
    }
  }
}