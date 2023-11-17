import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
