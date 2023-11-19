// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:shrine/detail.dart';
import 'package:shrine/add.dart';
import 'package:shrine/edit.dart';
import 'package:shrine/runPage.dart';
import 'package:shrine/profile.dart';

import 'package:shrine/savePage.dart';
import 'package:shrine/wish_list.dart';
import 'countdown.dart';
import 'login.dart';
import 'map.dart';
import 'home.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        '/map': (BuildContext context) => MapScreen(),
        '/login': (BuildContext context) => const LoginPage(),
        '/addPage' : (BuildContext context) => const AddPage(),
        '/detailPage' : (BuildContext context) => const DetailPage(),
        '/editPage' : (BuildContext context) => const EditPage(),
        '/profilePage' : (BuildContext context) => const ProfilePage(),
        '/wishlistPage' : (BuildContext context) => const WishListPage(),
        '/countdownPage' : (BuildContext context) => const CountdownPage(),
        '/runPage' : (BuildContext context) => const RunPage(),
        '/savePage' : (BuildContext context) => const SavePage(),
      },
      // TODO: Customize the theme (103)
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)