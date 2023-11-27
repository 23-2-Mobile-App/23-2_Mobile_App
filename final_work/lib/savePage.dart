import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'model/model_record.dart';
import 'model/record.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = Provider.of<RecordProvider>(context, listen: false);
    Record record = ModalRoute.of(context)!.settings.arguments as Record;

    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [Color(0xFF080910), Color(0xFF141926)],
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //   ),
              // ),
              color: Color(0xFF01C1FD),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                          Row(
                            children: [
                              // SizedBox(width: 310,),
                              // SizedBox(width: 30,),
                              // ElevatedButton(
                              //   child: const Text('Save'),
                                // onPressed: () => {}
                              // ),
                            ],
                          ),
                  SizedBox(height: 20,),
                  Text(
                    'Record',
                    style: const TextStyle(
                      fontSize: 40, // 적절한 폰트 크기로 설정
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 400,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color(0xFF13325A).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,0,0,0),
                    child: Container(
                      width: 500,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Lottie.asset(
                                  'assets/road.json',
                                  height: 70.0,
                                  width: 70.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,30,0,0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '     Distance  ${(record.distance).toStringAsFixed(2)} ',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'm\n',
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.grey
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Lottie.asset(
                                  'assets/timer.json',
                                  height: 100.0,
                                  width: 100.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,30,0,0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Time ${(record.time).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' sec\n',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.grey
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Lottie.asset(
                                  'assets/start_run.json',
                                  height: 100.0,
                                  width: 100.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,40,0,0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Pace ${(record.pace).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' m/s\n',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.grey
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent, // Set the button color to transparent
                        elevation: 0, // Set elevation to 0 to remove the shadow
                      ),
                      child: Text(
                        'Save',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                  ),
                ],
              ),
          ),
          ),
        );
      },
    );
  }
  }




// ElevatedButton(
// onPressed: () {
// recordProvider.createRecord(distance: record.distance, pace: record.pace, time: record.time, date: record.date, imgURL: record.imgURL);
// Navigator.pop(context);
// },
// child: Text("save"),
// ),
