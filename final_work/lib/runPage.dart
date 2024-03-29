import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/record.dart';

class RunPage extends StatefulWidget {
  const RunPage({Key? key}) : super(key: key);
  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  GlobalKey globalKey = GlobalKey();

  late GoogleMapController _controller;
  bool _isArrowButtonPressed = true;
  double distance = 0.0; // 이동 거리 (미터)
  double pace = 0.0; // 평균 속도 (m/s)
  Position? _previousLocation;
  late Timer _timer;
  double time = 0.0; // 경과 시간 (초)

  bool _myLocationEnabled = false;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  late StreamSubscription<Position> _locationSubscription;
  String? userEmail;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Record currentRecord = Record(
    date: Timestamp.now(),
    distance: 0.0,
    pace: 0.0,
    time: 0.0,
  );

  Completer<GoogleMapController> _controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
      _isArrowButtonPressed = true;
    _getCurrentLocation();
    _startTimer();
    _locationSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((Position position) {
      _onLocationChanged(position);
    });

    // Call _getCurrentLocation() when the widget is first created
    _getCurrentLocation();

    // Use a timer to call _getCurrentLo cation() every 10 seconds
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      _getCurrentLocation();
    });

    _getUserEmail();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isArrowButtonPressed) {
        setState(() {
          time += 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _locationSubscription.cancel();
    super.dispose();
  }

  void _onLocationChanged(Position position) {
    if (mounted) { // Check if the widget is still mounted
      final LatLng newPosition = LatLng(position.latitude, position.longitude);

      // Update the marker position
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('userLocation'),
            position: newPosition,
            infoWindow: InfoWindow(title: 'Your Location', snippet: userEmail ?? ''),
          ),
        );
      });

      // Add the current location to the polyline
      _polylineCoordinates.add(newPosition);

      // Update the polylines on the map
      _updatePolylines();
    }
  }

  void _updatePolylines() {
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('userPath'),
            color: Colors.blue,
            points: _polylineCoordinates,
            width: 5,
          ),
        );
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Wait for the controller to be initialized
      final GoogleMapController controller = await _controllerCompleter.future;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) {
        // Check if the widget is still mounted before updating the state
        return;
      }

      final cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
        tilt: 60, // Set the tilt to create a 3D effect
      );

      // Update the map camera
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // Update the marker position
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('userLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Your Location', snippet: userEmail ?? ''),
          ),
        );
      });

      // Add the current location to the polyline
      _polylineCoordinates.add(LatLng(position.latitude, position.longitude));

      // Update the polylines on the map
      _updatePolylines();

      setState(() {
        _myLocationEnabled = true;
      });

      if (_previousLocation != null) {
        double currentDistance = Geolocator.distanceBetween(
          _previousLocation!.latitude,
          _previousLocation!.longitude,
          position.latitude,
          position.longitude,
        );
        if(_isArrowButtonPressed == true){
          setState(() {
            distance += currentDistance;
            pace = distance / time;
          });
        }
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


  void _getUserEmail() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      userEmail = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
              _controllerCompleter.complete(controller);
              _getCurrentLocation(); // Call _getCurrentLocation() when the map is created
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.532600, 127.024612),
              zoom: 18,
              tilt: 60, // Set the tilt to create a 3D effect
            ),
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: false,
            // markers: _markers,
            polylines: _polylines,
          ),

          Center(
            child: Column(
              children: [
                const SizedBox(height: 600),
                SizedBox(
                  width: 400.0,
                  height: 250.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // 그림자의 색상 및 불투명도 설정
                          spreadRadius: 5, // 그림자의 확산 정도
                          blurRadius: 5, // 그림자의 흐림 정도
                          offset: Offset(7, 8), // 그림자의 위치 조정 (가로, 세로)
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 30,),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(30, 20,190,0),
                          child: DefaultTextStyle(
                            style: TextStyle(fontSize: 27, color: Colors.grey,fontWeight: FontWeight.bold),
                            child: Text('Running time',),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 30,),
                            DefaultTextStyle(
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                              child: Text('${_formatTime(time)}'),
                            ),
                            const SizedBox(width: 80,),
                            IconButton(
                              icon: const Icon(Icons.play_arrow, size: 60),
                              onPressed: () {
                                print("clicked ! aar");
                                  _isArrowButtonPressed = !_isArrowButtonPressed;

                                // Add any additional logic you want to perform when the button is pressed.
                              },
                            ),

                            IconButton(
                                icon: const Icon(Icons.stop,size: 60,),
                                onPressed: () async {
                                  _timer.cancel();
                                  currentRecord.distance = distance;
                                  currentRecord.pace = pace;
                                  currentRecord.time = time;
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context,'/savePage', arguments: currentRecord);
                                }
                            ),
                          ],
                        ),
                        Container(
                          width: 360,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF01C1FD).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2), // 그림자의 색상 및 불투명도 설정
                                spreadRadius: 4, // 그림자의 확산 정도
                                blurRadius: 5, // 그림자의 흐림 정도
                                offset: Offset(0, 3), // 그림자의 위치 조정 (가로, 세로)
                              ),
                            ],

                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                               Container(
                                 width: 100,
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     Image.asset('assets/runner.png',width: 30,height: 30),
                                     DefaultTextStyle(
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('${(distance / 1000).toStringAsFixed(2)}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
                                          Text('distance',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
                                        ],
                                      ), // check km
                              ),
                                   ],
                                 ),
                               ),
                              const VerticalDivider(
                                  color: Color.fromARGB(255, 211, 211, 211),
                                  thickness: 2.0),
                              Container(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset('assets/sweat.png',width: 30,height: 30),
                                     DefaultTextStyle(
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text( "--",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
                                          Text('Kcal',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
                                        ],
                                      ), // check km
                                    ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                  color: Color.fromARGB(255, 211, 211, 211),
                                  thickness: 2.0),
                               Container(
                                 width: 100,
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     Image.asset('assets/cheetah.png',width:30,height:30),
                                     DefaultTextStyle(
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('${pace.toStringAsFixed(2)}',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
                                          Text('pace',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
                                        ],
                                      ), // check km
                              ),
                                   ],
                                 ),
                               ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 8,
              child: Icon(Icons.my_location),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (_isArrowButtonPressed== true)
            AnimatedOpacity(

            opacity: 1.0 ,
            duration: Duration(milliseconds: 0),
            child: Container(

              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
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
                                  text: "${pace.toStringAsFixed(2)}",
                                ),
                                TextSpan(
                                  text: " m/s",
                                  style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          DefaultTextStyle(
                            style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            child: Text("${_formatTime(time)}",
    )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: const TextSpan(
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
                          DefaultTextStyle(
                              style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                              child: Text(" - -",
                              )),
                        ],
                      ),

                      SizedBox(height: 120),
                      IconButton(
                        icon: const Icon(Icons.pause_circle_filled, size: 120),
                        onPressed: () {
                          _isArrowButtonPressed = false;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  String _formatTime(double seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (seconds % 60).floor();

    // Use the `String.padLeft` method to add leading zeros
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }
}

class MarkerDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marker Detail'),
      ),
      body: Center(
        child: Text('Marker detail screen'),
      ),
    );
  }
}
