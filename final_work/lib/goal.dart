import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  StateMachineController? controller;
  SMIInput<double>? inputValue;
  double currentLevel = 0;
  int _currentIndex =2;
  String? email;
  String? user_name;
  String? user_RC;
  String? user_image;
  int? total_run;
  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;

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
    currentLevel = total_run!.toDouble();
    currentLevel = currentLevel*2;
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
          Positioned(
            top: MediaQuery.of(context).size.height/8,      //앱 화면 높이 double Ex> 692,
            left: MediaQuery.of(context).size.width/6-20,
            child: Container(
              width: 350,
              height: 400,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CircleAvatar(
                        //   radius: 30,
                        //   backgroundImage: NetworkImage(user_image ?? ''),
                        // ),
                        riveArtboard != null
                            ? Container(
                          width: 200,
                          height: 200,
                          child: Rive(artboard: riveArtboard!),
                        )    : CircularProgressIndicator(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Dance',style: TextStyle(fontFamily: 'Noto_Serif_KR')),
                          ],
                        ),
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
                    SizedBox(height: 40,),

                  ],
                ),
              ),
            ),

          ),
          Positioned(
          bottom: MediaQuery.of(context).size.height/17,      //앱 화면 높이 double Ex> 692,
          left: MediaQuery.of(context).size.width/3+10,
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
              child: Text('목표 런닝 횟수 7',),
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
        },
      ),
    );
  }
  void toggleDance(bool newValue) {
    setState(() => isDance?.value = newValue);
  }
}
