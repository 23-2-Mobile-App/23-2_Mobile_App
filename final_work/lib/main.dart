// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// import 'app.dart';
//
// // void main() => runApp(const ShrineApp());
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const ShrineApp());
//
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'model/model_auth.dart';
import 'model/model_item_provider.dart';
import 'model/model_wish.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  final status = await Geolocator.checkPermission();
  if (status == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ],
      child: const ShrineApp(),
    );
  }
}
