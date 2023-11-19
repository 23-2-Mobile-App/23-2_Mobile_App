import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PausePage extends StatefulWidget {
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

    _getUserEmail();
  }

  void _onLocationChanged(Position position) {
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
            myLocationButtonEnabled: true, // Enable the my location button
            markers: _markers,
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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 30,),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(30, 20,200,0),
                          child: DefaultTextStyle(
                            style: TextStyle(fontSize: 25, color: Colors.grey, ),
                            child: Text('Running time'),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 30,),
                            const DefaultTextStyle(
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                              child: Text('01:09:44'),
                            ),
                            const SizedBox(width: 10,),
                            IconButton(
                              icon: const Icon(Icons.play_arrow,size: 60,),
                              onPressed: () {},
                            ),
                            IconButton(
                                icon: const Icon(Icons.stop,size: 60,),
                                onPressed: () {}
                            ),
                            IconButton(
                                icon: const Icon(Icons.stop,size: 60,),
                                onPressed: () {}

                            ),
                          ],
                        ),
                        Container(
                          width: 350,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/runner.png',width: 30,height: 30),
                              const DefaultTextStyle(
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('10.9km',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
                                    Text('distance',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
                                  ],
                                ), // check km
                              ),
                              const VerticalDivider(
                                  color: Color.fromARGB(255, 211, 211, 211),
                                  thickness: 1.0),
                              Image.asset('assets/sweat.png',width: 30,height: 30),
                              const DefaultTextStyle(
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('5:20',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
                                    Text('Time',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
                                  ],
                                ), // check km
                              ),
                              const VerticalDivider(
                                  color: Color.fromARGB(255, 211, 211, 211),
                                  thickness: 1.0),
                              Image.asset('assets/cheetah.png',width:30,height:30),
                              const DefaultTextStyle(
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('5\'20\'\'',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
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

