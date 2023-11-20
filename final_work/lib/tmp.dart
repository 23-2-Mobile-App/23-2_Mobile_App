import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateMachineController? controller;
  SMIInput<double>? inputValue;
  double currentLevel = 0;
  int _currentIndex =2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RiveAnimation.asset(
            "assets/water-bar-demo.riv",
            fit: BoxFit.cover,
            onInit: (artboard) {
              controller = StateMachineController.fromArtboard(
                artboard,
                "State Machine",
              );
              if(controller != null) {
                artboard.addController(controller!);
                inputValue = controller?.findInput("Level");
                inputValue?.change(currentLevel);
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentLevel--;
                    });
                    inputValue?.change(currentLevel);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentLevel++;
                    });
                    inputValue?.change(currentLevel);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.green,
                  ),
                ),
              ],
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
        activeColor: Colors.deepPurpleAccent, // Set the color of active (selected) icon and text to black
        color: Colors.grey,
        onTap: (int index) {
          // Handle tab selection
          _currentIndex = index;
          // Add your logic based on the selected tab index
          switch (index) {
            case 0:

              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/tmpPage');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profilePage');
              break;
          }
        },
      ),
    );
  }
}
