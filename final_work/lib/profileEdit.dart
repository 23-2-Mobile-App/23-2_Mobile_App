import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/users.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userRCController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser as User;
  String? user_name;
  String? user_RC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profilePage');
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF080910), Color(0xFF141926)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage('assets/start_run.png')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      // initialValue: 'yourInitialValue', // You can set an initial value if needed
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _userRCController,
                      decoration: InputDecoration(
                        labelText: "User RC",
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      // initialValue: 'yourInitialValue', // You can set an initial value if needed
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _updateUserProfile();
                        Navigator.pushReplacementNamed(context, '/profilePage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDocument = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDocument.exists) {
        user_name = user.displayName;
        user_RC = userDocument.data()?['user_RC'];
      }
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      _getUserInfo();

      // Get the current values
      String? updatedName = _userNameController.text.isNotEmpty ? _userNameController.text : user_name;
      String? updatedRc = _userRCController.text.isNotEmpty ? _userRCController.text : user_RC;

      // Prepare the data to be updated
      Map<String, dynamic> updatedData = {};

      // Update only non-null fields
      if (updatedName != null) {
        updatedData['user_name'] = updatedName;
      }

      if (updatedRc != null) {
        updatedData['user_RC'] = updatedRc;
      }

      // Update the user information in Firestore
      await _firestore.collection('users').doc(user.uid).update(updatedData);

      print("Successfully Updated");
    } catch (error) {
      print('Error updating user profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update user profile'),
        ),
      );
    }
  }
}
