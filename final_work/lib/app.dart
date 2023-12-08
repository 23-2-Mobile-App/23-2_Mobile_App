import 'package:flutter/material.dart';
import 'package:shrine/profileEdit.dart';
import 'package:shrine/runPage.dart';
import 'package:shrine/profile.dart';
import 'package:shrine/savePage.dart';
import 'package:shrine/goal.dart';
import 'countdown.dart';
import 'login.dart';
import 'map.dart';
import 'home.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/mapPage': (BuildContext context) => MapScreen(),
        '/login': (BuildContext context) => const LoginPage(),
        '/profilePage' : (BuildContext context) => const ProfilePage(),
        '/countdownPage' : (BuildContext context) => const CountdownPage(),
        '/runPage' : (BuildContext context) => const RunPage(),
        '/savePage' : (BuildContext context) => const SavePage(),
        '/goalPage' : (BuildContext context) => const GoalPage(),
        '/edit' : (BuildContext context) => const ProfileEditPage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}