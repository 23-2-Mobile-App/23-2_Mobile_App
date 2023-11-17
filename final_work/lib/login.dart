import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'model/model_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthProvider _authProvider = FirebaseAuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF01C1FD),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Lottie.asset('assets/bear.json'),
                Text(
                  "Kupyer Running Club",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0, // 원하는 폰트 크기로 조정
                  ),
                ),
                const SizedBox(height: 16.0),
                // SizedBox(height: 200,),
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await _authProvider.signInWithGoogle();
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('GOOGLE'),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _authProvider.signInAnonymously();
                      if (_authProvider.errorMessage != null) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Guest'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 120.0),
          ],
        ),
      ),
    );
  }
}
