import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex =3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF01C1FD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<FirebaseAuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.currentUser == null) {
                  return CircularProgressIndicator();
                }
                if (authProvider.currentUser?.isAnonymous ?? false) {
                  // Display information for anonymous user
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'http://handong.edu/site/handong/res/img/logo.png',
                        width: 100,
                        height: 100,
                      ),
                      Text('UID: ${authProvider.currentUser?.uid ?? "Anonymous"}'),
                      Text('Email: Anonymous'),
                    ],
                  );
                } else {
                  // Display information for authenticated user
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          authProvider.currentUser?.photoURL ?? '',
                        ),
                      ),
                      Text('UID: ${authProvider.currentUser?.uid ?? ""}'),
                      Text('Email: ${authProvider.currentUser?.email ?? ""}'),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('SeokWon Kim', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 20),

            const Text(
              'I promise to take the test honestly before GOD',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
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
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/mapPage');
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}
