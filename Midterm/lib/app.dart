import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'home.dart';
import 'login.dart';
import 'model/product.dart';
import 'search.dart';
import 'favorite.dart';
import 'mypage.dart';
import 'hoteldetail.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/login/signup': (BuildContext context) => const SignUpPage(),
        '/': (BuildContext context) => const HomePage(),
        '/detail': (BuildContext context) {
          final hotel = ModalRoute.of(context)!.settings.arguments as Hotel;
          return HotelDetailPage(hotel: hotel);
        },
        '/favorite': (BuildContext context) => FavoritePage(),
        '/search': (BuildContext context) => const SearchPage(),
        '/mypage': (BuildContext context) => MyPagePage(),
      },
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
