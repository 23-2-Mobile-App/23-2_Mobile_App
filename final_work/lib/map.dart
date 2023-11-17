import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              _getCurrentLocation();
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(36.102525378796635, 129.38962878455183),
              zoom: 20.0,
            ),
          ),
          SizedBox(width: 200,height: 200,),
          Positioned(
            bottom: 150.0, // Adjust the position as needed
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: InkWell(
                onTap: () {
                  // Handle button tap
                  // You can navigate to another screen or perform any other action
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/start_run.png', // Replace with your custom button image path
                      height: 100.0,


                      width: 100.0,
                    ),
                    Image.asset(
                      'assets/start.png', // Replace with your custom button image path
                      height: 60.0,
                      width: 60.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15.0, // Adjust the zoom level as needed
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }
}
