import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'model/model_auth.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;
  final FirebaseAuthProvider _authProvider = FirebaseAuthProvider();

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/dash_flutter_muscot.riv').then(
          (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller =
          StateMachineController.fromArtboard(artboard, 'birb');
          if (controller != null) {
            artboard.addController(controller);
            isDance = controller.findSMI('dance');
            isLookUp = controller.findSMI('look up');
          }
          setState(() => riveArtboard = artboard);
        } catch (e) {
          print(e);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF01C1FD),
        child:
            Column(
              children: <Widget>[

                const SizedBox(height: 100.0),
                Container(
                  width: 400,
                  height: 400,
                  child: Rive(
                    artboard: riveArtboard!,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Dance'),
                    Switch(
                      value: isDance!.value,
                      onChanged: (value) => toggleDance(value),
                    ),
                  ],
                ),
                Text(
                  "Kupyer Running Club",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0, // 원하는 폰트 크기로 조정
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Look up'),
                  onPressed: () => isLookUp?.value = true,
                ),
                const SizedBox(height: 12),
                Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await _authProvider.signInWithGoogle(context);
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('GOOGLE'),
                  ),
                ),
              ],
            ),
        ),

    );
  }
  void toggleDance(bool newValue) {
    setState(() => isDance!.value = newValue);
  }
}
