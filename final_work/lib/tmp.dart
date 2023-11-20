import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'model/model_auth.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(0.0);
  StateMachineController? controller;
  SMIInput<double>? valueInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // const SizedBox(height: 32),
            // const Expanded(child: SizedBox()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                  SizedBox(
                    width: 450,
                    height: 200,
                    child: RiveAnimation.asset(
                      "assets/water.riv",
                      onInit: (artboard) {},
                    ),
                  ),
                // ValueListenableBuilder<double>(
                //   valueListenable: valueNotifier,
                //   builder: (context, value, _) {
                //     return RotatedBox(
                //       quarterTurns: 3,
                //       child: Slider(
                //         value: value,
                //         onChanged: (val) {
                //           valueNotifier.value = val;
                //         },
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
