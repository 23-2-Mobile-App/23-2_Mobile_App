import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? email;
  String? user_name;
  String? user_RC;
  String? user_image;
  int? total_run;

  void _getUserInfo() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      email = user.email;
      user_name= user.displayName;
      user_image=user.photoURL;
      total_run=1;
      user_RC="Kuyper";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: RiveAnimation.asset(
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
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             currentLevel--;
          //           });
          //           inputValue?.change(currentLevel);
          //         },
          //         child: Container(
          //           height: 50,
          //           width: 50,
          //           color: Colors.red,
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             currentLevel++;
          //           });
          //           inputValue?.change(currentLevel);
          //         },
          //         child: Container(
          //           height: 50,
          //           width: 50,
          //           color: Colors.green,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Positioned(
            top: MediaQuery.of(context).size.height/8,      //앱 화면 높이 double Ex> 692,
            left: MediaQuery.of(context).size.width/6-20,
            child: Container(
              width: 350,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF01C1FD).withOpacity(0.0),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 그림자의 색상 및 불투명도 설정
                    spreadRadius: 5, // 그림자의 확산 정도
                    blurRadius: 5, // 그림자의 흐림 정도
                    offset: Offset(7, 8), // 그림자의 위치 조정 (가로, 세로)
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CircleAvatar(
                    //   radius: 30,
                    //   backgroundImage: NetworkImage(user_image ?? ''),
                    // ),
                    SizedBox(width: 22), // Add some space between the image and text
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
                          Text('$user_name님'),
                          SizedBox(height: 8),
                          Text('이번주 런닝 횟수는 $total_run회입니다'),
                          SizedBox(height: 8),
                          Text('$user_RC RC'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          //   const Text(
          //     "Kupyer Running Club",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 30.0,
          //       fontFamily: 'Kanit',
          // ),
          // ),
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
