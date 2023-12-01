import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/painting/gradient.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'model/model_record.dart';
import 'model/record.dart';
import 'package:rive/rive.dart';
import 'package:flutter/painting.dart';


class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  SMIBool? isDance;
  SMITrigger? isLookUp;
  Artboard? riveArtboard;

  User? user = FirebaseAuth.instance.currentUser;

  final List<String> motivationalQuotes = [
    "Believe you can and you're halfway there.",
    "The only limit to our realization of tomorrow will be our doubts of today.",
    "Don't watch the clock, do what it does. Keep going.",
    // Add more quotes as needed
  ];

  // Random number generator
  final Random random = Random();

  String get randomQuote => motivationalQuotes[random.nextInt(motivationalQuotes.length)];

  @override
  void initState() {
    super.initState();
    loadRive();
  }

  Widget build(BuildContext context) {
    RecordProvider recordProvider =
    Provider.of<RecordProvider>(context, listen: false);
    Record record = ModalRoute.of(context)!.settings.arguments as Record;

    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFF01C1FD),
          body: Center(
            child: Container(
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [Color(0xFF080910), Color(0xFF141926)],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //   ),
              // ),
              color: Color(0xFF01C1FD),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Run Summary',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (riveArtboard != null)
                    Container(
                      width: 300,
                      height: 300,
                      child: Rive(artboard: riveArtboard!),
                    )
                  else
                    CircularProgressIndicator(),



                  SizedBox(height: 20),
                  Container(
                    width: 350,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRunInfo(
                          lottieAsset: 'assets/road.json',
                          label: 'Distance',
                          value: '${record.distance.toStringAsFixed(2)} m',
                        ),
                        SizedBox(height: 10),
                        _buildRunInfo(
                          lottieAsset: 'assets/timer.json',
                          label: 'Time',
                          value: '${record.time.toStringAsFixed(2)} sec',
                        ),
                        SizedBox(height: 10),
                        _buildRunInfo(
                          lottieAsset: 'assets/start_run.json',
                          label: 'Pace',
                          value: '${record.pace.toStringAsFixed(2)} m/s',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  SizedBox(height: 5),
                  Container(
                    width: 300,
                    child:  AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          randomQuote,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1.2,
                          ),
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                      totalRepeatCount: 4,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onPressed: () async {
                      await recordProvider.createRecord(
                          date: Timestamp.now(), // Adjust the timestamp as needed
                          distance: record.distance,
                          pace: record.pace,
                          time: record.time,
                          imgURL: 'url_placeholder', // Replace with the actual image URL
                      );

                      CollectionReference runsCollection = FirebaseFirestore.instance.collection('users');

                      // Use a transaction to update the total_run field
                      await FirebaseFirestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(runsCollection.doc(user?.uid));
                        int currentTotalRun = snapshot['total_run'] ?? 0;

                        // Increment the total_run value by 1
                        int newTotalRun = currentTotalRun + 1;

                        // Update the total_run field in Firestore
                        transaction.update(runsCollection.doc(user?.uid), {'total_run': newTotalRun});
                      });

                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRunInfo({
    required String lottieAsset,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          child: Lottie.asset(
            lottieAsset,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> loadRive() async {
    final data = await rootBundle.load('assets/dash_flutter_muscot.riv');
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
  }
}