import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive; // Import Rive with an alias

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  rive.StateMachineController? controller;
  rive.SMIInput<double>? inputValue;
  double currentLevel = 0;
  int _currentIndex = 2;
  String? email;
  String? user_name;
  String? user_RC;
  String? user_image;
  int? total_run;
  rive.Artboard? riveArtboard; // Use the qualified Rive name
  rive.SMIBool? isDance; // Use the qualified Rive name
  rive.SMITrigger? isLookUp; // Use the qualified Rive name

  void _getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // Get additional user information from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDocument = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDocument.exists) {
        // Access the fields from the user document
        user_name = user.displayName;
        user_image = user.photoURL;
        total_run = userDocument.data()?['total_run'];
        user_RC = userDocument.data()?['user_RC'];
      }
    }
  }

  Future<void> loadRive() async {
    final data = await rootBundle.load('assets/dash_flutter_muscot.riv');
    try {
      final file = rive.RiveFile.import(data); // Use the qualified Rive name
      final artboard = file.mainArtboard;
      var controller = rive.StateMachineController.fromArtboard(
          artboard, 'birb'); // Use the qualified Rive name
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
    _getUserInfo();
    loadRive();
    if (total_run!.toInt() > 0) {
      toggleDance(true);
    }
    currentLevel = total_run!.toDouble();
    currentLevel = currentLevel * 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Goal', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF080910), Color(0xFF141926)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            child: rive.RiveAnimation.asset(
              "assets/water-bar-demo.riv",
              fit: BoxFit.cover,
              onInit: (artboard) {
                controller = rive.StateMachineController.fromArtboard(
                  artboard,
                  "State Machine",
                );
                if (controller != null) {
                  artboard.addController(controller!);
                  inputValue = controller?.findInput("Level");
                  inputValue?.change(currentLevel);
                }
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 8,
            left: MediaQuery.of(context).size.width / 6 - 20,
            child: Container(
              width: 500,
              height: 400,
              child: Padding(
                padding: EdgeInsets.only(left: 1.0, top: 20.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        riveArtboard != null
                            ? Container(
                          width: 120,
                          height: 120,
                          child: rive.Rive(artboard: riveArtboard!), // Use the qualified Rive name
                        )
                            : CircularProgressIndicator(),
                        SizedBox(width: 22),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'inter',
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$user_RC RC\n',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF51C4F2),
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'inter',
                                ),
                              ),
                              Text('$user_name님'),
                              SizedBox(height: 8),
                              Text('이번주 런닝 횟수는 $total_run회입니다'),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 17,
            right: MediaQuery.of(context).size.width / 3 + 10,
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              child: Text('목표 런닝 횟수 7'),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              child: const Text('Look up'),
              onPressed: () => isLookUp?.value = true,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/mapPage');
                break;
              case 2:
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
            icon: Icon(Icons.emoji_events),
            title: Text("Run"),
            selectedColor: Color(0xFF51C4F2),
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.chat),
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
    );
  }

  void toggleDance(bool newValue) {
    setState(() => isDance?.value = newValue);
  }
}
