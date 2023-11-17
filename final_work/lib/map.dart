import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void initState() {
    super.initState();
    _locationSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 10, // set your desired distance filter
    ).listen((Position position) {
      _onLocationChanged(position);
    });
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
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      );
    });

    // Add the current location to the polyline
    _polylineCoordinates.add(newPosition);

    // Update the polylines on the map
    _updatePolylines();
  }

  void _updatePolylines() {
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: PolylineId('userPath'),
        color: Colors.blue,
        points: _polylineCoordinates,
        width: 5,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _locationSubscription.cancel();
    super.dispose();
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

    // Update the marker position
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('userLocation'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _controller = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.532600, 127.024612), // 서울 시청 위치
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
                SizedBox(height: 100),
                SizedBox(
                  width: 400.0,
                  height: 200.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        'info',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 300),
                Image.asset(
                  'assets/start_run.png',
                  height: 100.0,
                  width: 100.0,
                ),
                Image.asset(
                  'assets/start.png',
                  height: 60.0,
                  width: 60.0,
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

