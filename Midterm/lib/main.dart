import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'hotelprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HotelProvider(),
      child: const ShrineApp(),
    ),
  );
}
