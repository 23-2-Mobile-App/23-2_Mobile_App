import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/model_auth.dart';
import 'model/model_record.dart';
import 'model/record.dart';
import 'model/users.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF51C4F2),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 40.0, 16.0, 16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/eagle.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요, ${_firebaseAuthProvider.getUsername() ?? ''} 님',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              'Beginner',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 25.0, 16.0, 25.0),
                  child: Text(
                    'Running Record',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'kanit',
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Widget>>(
                    future: _buildGridCards(context, recordProvider),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return Text('No data available');
                      }

                      return GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(16.0),
                        childAspectRatio: 13.0 / 10.0, // Adjust this ratio to change the size of the cards
                        children: snapshot.data!,
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: Colors.white,
              style: TabStyle.react,
              items: [
                TabItem(icon: Icons.menu, title: 'DashBoard'),
                TabItem(icon: Icons.emoji_events, title: 'Run'),
                TabItem(icon: Icons.chat, title: 'Goal'),
                TabItem(icon: Icons.person, title: 'Profile'),
              ],
              initialActiveIndex: _currentIndex,
              activeColor: Color(0xFF51C4F2), // Set the color of active (selected) icon and text to black
              color: Colors.grey,
              onTap: (int index) {
                // Handle tab selection
                  _currentIndex = index;
                // Add your logic based on the selected tab index
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(context, '/mapPage');
                    break;
                  case 2:
                    Navigator.pushReplacementNamed(context, '/goalPage');
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(context, '/profilePage');
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<List<Widget>> _buildGridCards(
      BuildContext context, RecordProvider recordProvider) async {
    List<Widget> cards = [];

    try {
      List<Record> records = await recordProvider
          .getRecords(); // Replace this with your actual method to fetch records

      for (Record record in records) {
        Widget card = Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0), // Adjust the left padding as needed
                          child: Text(
                            _formatDate(record.date.toDate()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                          child: Text(
                            _formatday(record.date.toDate()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            _formatDistance(record.distance),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            '${record.pace.toStringAsFixed(2)} km/hr',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            _formatTime(record.time),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 25.0,
                top: 50.0,
                child: Image.asset(
                  'assets/start_run.png',
                  width: 60, // Adjust the width as needed
                  height: 60, // Adjust the height as needed
                ),
              ),
            ],
          ),
        );
        cards.add(card);
      }
    } catch (error) {
      print('Error fetching records: $error');
    }

    return cards;
  }

  String _formatday(DateTime date) {
    final day = DateFormat.d().format(date);
    final suffix = _getDaySuffix(int.parse(day));

    return DateFormat("h:mm a").format(date);
  }

  String _formatDate(DateTime date) {
    final day = DateFormat.d().format(date);
    final suffix = _getDaySuffix(int.parse(day));

    return DateFormat("MMMM $day").format(date) + suffix + DateFormat(", y").format(date);
  }


  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    final int lastDigit = day % 10;
    switch (lastDigit) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _formatDistance(double distanceInMeters) {
    // Convert meters to kilometers
    double distanceInKm = distanceInMeters / 1000.0;

    // Format distance to 2 decimal digits
    String formattedDistance = distanceInKm.toStringAsFixed(2);

    return '$formattedDistance km';
  }

  String _formatTime(double timeInSeconds) {
    if (timeInSeconds >= 3600.0) {
      // Convert seconds to hours
      double timeInHours = timeInSeconds / 3600.0;
      return '${timeInHours.toStringAsFixed(2)} hours';
    } else if (timeInSeconds >= 60.0) {
      // Convert seconds to minutes
      double timeInMinutes = timeInSeconds / 60.0;
      return '${timeInMinutes.toStringAsFixed(2)} minutes';
    } else {
      return '${timeInSeconds.toStringAsFixed(2)} seconds';
    }
  }
}