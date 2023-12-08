import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/model_auth.dart';
import 'model/model_record.dart';
import 'model/record.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();
  bool showChart = false; // Variable to control whether to show the chart or not

  int _currentIndex = 0;
  late List<Record> records;
  @override
  Widget build(BuildContext context) {
    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF080910), Color(0xFF141926)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
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
                        IconButton(
                          icon: Icon(Icons.show_chart, color: Colors.white,),
                          iconSize: 50,
                          onPressed: () {
                            setState(() {
                              showChart = !showChart;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (showChart)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChart(
                          _buildLineChart(records),
                        ),
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          childAspectRatio: 13.0 / 10.0,
                          // Adjust this ratio to change the size of the cards
                          children: snapshot.data!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
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
                });
              },
              items: [
                SalomonBottomBarItem(
                  icon: Icon(Icons.menu),
                  title: Text("Dashboard"),
                  selectedColor: Color(0xFF51C4F2),
                  unselectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.directions_run),
                  title: Text("Run"),
                  selectedColor: Color(0xFF51C4F2),
                  unselectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.emoji_events),
                  title: Text("Goal"),
                  selectedColor: Color(0xFF51C4F2),
                  unselectedColor: Colors.white,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Profile"),
                  selectedColor: Color(0xFF51C4F2),
                  unselectedColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  LineChartData _buildLineChart(List<Record>? records) {
    if (records == null || records.isEmpty) {
      // records가 null이거나 비어있을 때 빈 컨테이너 반환
      return LineChartData(); // 빈 컨테이너 반환 또는 원하는 다른 기본값 설정
    }

    // records.date를 기준으로 정렬
    records.sort((a, b) => a.date.toDate().compareTo(b.date.toDate()));

    List<FlSpot> spots = [];

    // Create data points for the line chart using date and distance
    for (int i = 0; i < records.length; i++) {
      DateTime date = records[i].date.toDate();
      double distance = records[i].distance;
      spots.add(FlSpot(i.toDouble(), distance));
    }

    // Customize other aspects of the line chart as needed
    return LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          margin: 12,
          getTextStyles: (BuildContext context, double value) =>
              TextStyle(color: Colors.white, fontSize: 10),
          getTitles: (value) {
            // Y축 레이블을 5km 간격으로 표시
            if (value == 0) {
              return '0';
            } else if (value % 1000 == 0) {
              return '${(value / 1000).toInt()} km';
            } else {
              return '';
            }
          },
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (BuildContext context, double value) =>
              TextStyle(color: Colors.white, fontSize: 8),
          getTitles: (double value) {
            int index = value.toInt().clamp(0, records.length - 1);
            if (index >= 0 && index < records.length && spots.any((spot) => spot.x == value)) {
              return DateFormat('MM/dd').format(records[index].date.toDate());
            }
            return '';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: records.length.toDouble() - 1,
      minY: 0,
      maxY: records.map((record) => record.distance).reduce(math.max).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          colors: [Colors.blue],
          belowBarData: BarAreaData(show: false),
          dotData: FlDotData(show: true), // Show dots on the line chart
          // belowSpotsLine: const BorderSide(color: Colors.transparent),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildGridCards(
      BuildContext context, RecordProvider recordProvider) async {
    List<Widget> cards = [];
    try {
       records = await recordProvider.getRecords();
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
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          // Adjust the left padding as needed
                          child: Text(
                            _formatDate(record.date.toDate()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          // Adjust the left padding as needed
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
                            '${record.pace.toStringAsFixed(2)} m/s',
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

    return DateFormat("MMMM $day").format(date) +
        suffix +
        DateFormat(", y").format(date);
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
    double distanceInKm = distanceInMeters / 1000.0;
    String formattedDistance = distanceInKm.toStringAsFixed(2);
    return '$formattedDistance km';
  }

  String _formatTime(double timeInSeconds) {
    if (timeInSeconds >= 3600.0) {
      double timeInHours = timeInSeconds / 3600.0;
      return '${timeInHours.toStringAsFixed(2)} hours';
    } else if (timeInSeconds >= 60.0) {
      double timeInMinutes = timeInSeconds / 60.0;
      return '${timeInMinutes.toStringAsFixed(2)} minutes';
    } else {
      return '${timeInSeconds.toStringAsFixed(2)} seconds';
    }
  }
}
