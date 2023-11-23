import 'dart:async';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  bool _myLocationEnabled = false;
  Set<Marker> _markers = {};
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
    _locationSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ).listen((Position position) {
      _onLocationChanged(position);
    });

    // Call _getCurrentLocation() when the widget is first created
    _getCurrentLocation();

    // Use a timer to call _getCurrentLocation() every 10 seconds
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _getCurrentLocation();
    });

    _locationTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
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
        Marker(
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
        Marker(
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

  void _getUserInfo() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      email = user.email;
      user_name= user.displayName;
      user_image=user.photoURL;
      total_run=1;
      user_RC="Kuyper";
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
              children: [
                const SizedBox(height: 100),
                SizedBox(
                  width: 400.0,
                  height: 200.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF2f294b).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(user_image ?? ''),
                          ),
                          SizedBox(width: 22), // Add some space between the image and text
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
                                Text('$user_name님'),
                                SizedBox(height: 8),
                                Text('이번주 런닝 횟수는 $total_run회입니다'),
                                SizedBox(height: 8),
                                Text('$user_RC RC'),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  child: Image.asset(
                    'assets/start_run.png',
                    height: 100.0,
                    width: 100.0,
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
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.white,
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.menu, title: 'DashBoard'),
          TabItem(icon: Icons.emoji_events, title: 'Run'),
          TabItem(icon: Icons.chat, title: 'Goal'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _currentIndex,
        activeColor: Color(0xFF51C4F2), // Set the color of active (selected) icon and text to black
        color: Colors.grey,
        onTap: (int index) {
          // Handle tab selection
          _currentIndex = index;
          // Add your logic based on the selected tab index
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
        },
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

