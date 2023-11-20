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

  Future<void> loadRive() async {
    final data = await rootBundle.load('assets/dash_flutter_muscot.riv');
    try {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'birb');
      if (controller != null) {
        artboard.addController(controller);
        isDance = controller.findSMI('dance');
        isLookUp = controller.findSMI('look up');
      }
      setState(() => riveArtboard = artboard);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadRive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF01C1FD),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100.0),
            riveArtboard != null
                ? Container(
              width: 400,
              height: 400,
              child: Rive(artboard: riveArtboard!),
            )
                : CircularProgressIndicator(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Dance'),
                Switch(
                  value: isDance?.value ?? false,
                  onChanged: (value) => toggleDance(value),
                ),
              ],
            ),
            Text(
              "Kupyer Running Club",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
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
                  bool success =
                  await _authProvider.signInWithGoogle(context);
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
    setState(() => isDance?.value = newValue);
  }
}
