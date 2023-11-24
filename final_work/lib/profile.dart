import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;
  String? user_name;
  String? user_RC;
  String? user_image;
  int? total_run;

  void _getUserInfo() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      user_name= user.displayName;
      user_image=user.photoURL;
      total_run=1;
      user_RC="Kuyper";
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUserInfo();
    return Scaffold(
      backgroundColor: const Color(0xFF51C4F2), // Set the background color here
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color(0xFF51C4F2),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Log out the user and navigate to the login page
              Provider.of<FirebaseAuthProvider>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Consumer<FirebaseAuthProvider>(
                builder: (context, authProvider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          authProvider.currentUser?.photoURL ?? '',
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter',
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 7),
                            Text('Email: ${authProvider.currentUser?.email ?? ""}'),
                            SizedBox(height: 7),
                            Text('$user_name님'),
                            SizedBox(height: 7),
                            Text('$user_RC RC'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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
}
