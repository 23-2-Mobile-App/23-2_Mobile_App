import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PausePage extends StatefulWidget {
  const PausePage({Key? key}) : super(key: key);
  @override
  _PausePageState createState() => _PausePageState();
}

class _PausePageState extends State<PausePage> {
  late GoogleMapController _controller;
  bool _myLocationEnabled = false;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  late StreamSubscription<Position> _locationSubscription;
  String? userEmail;

  Completer<GoogleMapController> _controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();

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

    _getUserEmail();
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
    // Wait for the controller to be initialized
    final GoogleMapController controller = await _controllerCompleter.future;

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
            ),
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: false,
            markers: _markers,
            polylines: _polylines,
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 600),
                Container(
                  width: 400.0,
                  height: 300.0,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              const DefaultTextStyle(
                                style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0,20,140,0),
                                  child: Text(
                                    'Running Record',
                                    style:  TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30,),
                                  DefaultTextStyle(
                                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                                    child: Text(
                                      '01:10:35',
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 60,),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 70,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.stop,
                                      size: 70,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40,),
                              Container(
                                width: 370,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/start_run.png',width: 20,height: 20,),
                                        const DefaultTextStyle(
                                          style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '12.3',
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                ' km',
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                        color: Color.fromARGB(255, 211, 211, 211),
                                        thickness: 1.0),
                                    Row(
                                      children: [
                                        Image.asset('assets/start_run.png',width: 20,height: 20,),
                                        const DefaultTextStyle(
                                          style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '12.3',
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                ' km',
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                        color: Color.fromARGB(255, 211, 211, 211),
                                        thickness: 1.0),
                                    Row(
                                      children: [
                                        Image.asset('assets/start_run.png',width: 20,height: 20,),
                                        const DefaultTextStyle(
                                          style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, fontStyle: FontStyle.italic),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '12.3',
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                ' km',
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
