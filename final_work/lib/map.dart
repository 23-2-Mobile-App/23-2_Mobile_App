import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  SMIBool? isDance;
  SMITrigger? isLookUp;
  Artboard? riveArtboard;
  late GoogleMapController _controller;
  bool _myLocationEnabled = false;
  Set<maps.Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  late StreamSubscription<Position> _locationSubscription;
  String? email;
  String? user_name;
  String? user_RC;
  String? user_image;
  int? total_run;
  int _currentIndex =0;
  Timer? _locationTimer;


  @override
  void initState() {
    super.initState();
    _currentIndex =1;
    loadRive();
    _locationSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((Position position) {
      _onLocationChanged(position);
    });

    // Call _getCurrentLocation() when the widget is first created
    _getCurrentLocation();

    // Use a timer to call _getCurrentLocation() every 10 seconds
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      _getCurrentLocation();
    });

    _locationTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      _getCurrentLocation();
    });
    
    _getUserInfo();
  }

  void _onLocationChanged(Position position) {
    final LatLng newPosition = LatLng(position.latitude, position.longitude);

    if(mounted)
    setState(() {
      _markers.clear();
      _markers.add(
        maps.Marker(
          markerId: MarkerId('userLocation'),
          position: newPosition,
          infoWindow: InfoWindow(title: 'Your Location', snippet: user_name ?? ''),
        ),
      );
    });

    // Add the current location to the polyline
    _polylineCoordinates.add(newPosition);

    // Update the polylines on the map

  }


  Future<void> _getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error getting current location: $e");
      return;
    }

    final cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );

    // Update the map camera
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if(mounted)
    setState(() {
      _markers.clear();
      _markers.add(
        maps.Marker(
          markerId: MarkerId('userLocation'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Your Location', snippet: user_name ?? ''),
        ),
      );
    });

    // Add the current location to the polyline
    _polylineCoordinates.add(LatLng(position.latitude, position.longitude));

    // Update the polylines on the map
  if(mounted)
    setState(() {
      _myLocationEnabled = true;
    });
  }

  void _getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // Get additional user information from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDocument = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDocument.exists) {
        // Access the fields from the user document
        user_name = user.displayName;
        user_image = user.photoURL;
        total_run = userDocument.data()?['total_run'];
        user_RC = userDocument.data()?['user_RC'];
      }
    }
  }

  Future<void> loadRive() async {
    final data = await rootBundle.load('assets/dash_flutter_muscot.riv');
    try {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'birb');
      if (controller != null) {
        artboard.addController(controller);
        isDance = controller.findSMI('dance');
        isLookUp = controller.findSMI('look up');
      }
      setState(() => riveArtboard = artboard);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _locationSubscription.cancel();
    _locationTimer?.cancel(); // Cancel the timer

    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
              _getCurrentLocation(); // Call _getCurrentLocation() when the map is created
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.532600, 127.024612),
              zoom: 18,
            ),
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: true, // Enable the my location button
            // markers: _markers,
            polylines: _polylines,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Container(
                  width: 400,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: flutter.LinearGradient(
                      colors: [Color(0xFF080910), Color(0xFF141926)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 35.0, top: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            riveArtboard != null
                                ? Container(
                              width: 120,
                              height: 120,
                              child: Rive(artboard: riveArtboard!),
                            )
                                : CircularProgressIndicator(),
                            SizedBox(width: 22),
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'inter',
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // Check if user_RC is not equal to "NEED TO SET ON PROFILE PAGE" before displaying
                                  Text(
                                    user_RC != "NEED TO SET ON PROFILE PAGE"
                                        ? '$user_RC RC\n'
                                        : '', // Display empty string if user_RC is "NEED TO SET ON PROFILE PAGE"
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFF51C4F2),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'inter',
                                    ),
                                  ),
                                  Text('$user_name님'),
                                  SizedBox(height: 8),
                                  Text('이번주 런닝 횟수는 $total_run회입니다'),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 300),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/countdownPage',
                    );
                  },
                  child: Lottie.asset(
                    'assets/start_run.json',
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/countdownPage',
                    );
                  },
                  child: Image.asset(
                    'assets/start.png',
                    height: 60.0,
                    width: 60.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/');
                break;
              case 1:
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/goalPage');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profilePage');
                break;
            }
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.menu),
            title: Text("Dashboard"),
            selectedColor: Color(0xFF51C4F2),
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.emoji_events),
            title: Text("Run"),
            selectedColor: Color(0xFF51C4F2),
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.chat),
            title: Text("Goal"),
            selectedColor: Color(0xFF51C4F2),
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Color(0xFF51C4F2),
            unselectedColor: Colors.white,
          ),
        ],
      ),
    );
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

