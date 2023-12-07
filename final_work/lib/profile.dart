import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'model/model_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;
  String? userName;
  String? userRC;

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    }

    throw Exception('User not authenticated');
  }
  TextEditingController _trophyInputController = TextEditingController();

  Future<void> _showTrophyInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Running Goal',style: TextStyle(color: Colors.white),),
          content: TextField(
            controller: _trophyInputController,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateGoalInDatabase();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateGoalInDatabase() async {
    try {
      int trophyCount = int.tryParse(_trophyInputController.text) ?? 0;
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'goal': trophyCount,
        });

        print('Goal updated successfully: $trophyCount');
      }
    } catch (error) {
      print('Error updating goal: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update goal'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  const Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ), child: Text('Loading...'),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Text('Error: User information not available'),
            ),
          );
        }

        DocumentSnapshot<Map<String, dynamic>> userDocument = snapshot.data!;
        userName = userDocument.data()?['user_name'];
        userRC = userDocument.data()?['user_RC'];

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  Provider.of<FirebaseAuthProvider>(context, listen: false).signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF080910), Color(0xFF141926)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.network(
                            Provider.of<FirebaseAuthProvider>(
                                context,
                                listen: false)
                                .currentUser
                                ?.photoURL ??
                                '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Consumer<FirebaseAuthProvider>(
                    builder: (context, authProvider, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                Text(
                                    'Email: ${authProvider.currentUser?.email ?? ""}'),
                                SizedBox(height: 7),
                                Text('$userName님'),
                                SizedBox(height: 7),
                                Text('$userRC RC'),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                          'Edit Profile', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 60),
                  IconButton(
                    icon: Lottie.asset(
                      'assets/trophy.json',
                      height: 250.0,
                      width: 250.0,
                    ),
                    onPressed: () {
                      _showTrophyInputDialog(context);
                    },
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Change you Goal!",
                        textStyle: TextStyle(
                          fontSize: 20,
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SalomonBottomBar(
            backgroundColor: Colors.black,
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
                    Navigator.pushReplacementNamed(context, '/goalPage');
                    break;
                  case 3:
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
        );
      },
    );
  }
}
