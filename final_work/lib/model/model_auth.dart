import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? errorMessage = '';
  User? get currentUser => _auth.currentUser;
  void notifyListenersOnLogout() {
    notifyListeners();
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // 사용자가 로그인을 취소한 경우
        print('사용자가 Google 로그인을 취소했습니다.');
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if the user's email domain is allowed
      if (user != null && user.email != null && user.email!.endsWith('@handong.ac.kr')) {
        // Check if the user document exists, if not, create it
        await _createOrUpdateUserDocument(user);

        print("구글 로그인 성공! 사용자 ID: ${user.uid}");
        notifyListeners();
        return true;
      } else {
        // Sign out the user and show an AlertDialog
        await _auth.signOut();
        await googleSignIn.signOut();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('로그인 오류'),
              content: Text('한동대 학생만 로그인 가능합니다'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );

        return false;
      }
    } catch (e) {
      errorMessage = "구글 로그인에 실패했습니다: $e";
      return false;
    }
  }

  String? getUsername() {
    return currentUser?.displayName;
  }
  Future<void> _createOrUpdateUserDocument(User? user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);

    if (!(await userDoc.get()).exists) {
      // If the user document doesn't exist, create it with initial values
      await userDoc.set({
        'uid': user?.uid,
        'email': user?.email,
        'user_name': user?.displayName,
        'sum_distance': 0,
        'sum_time': 0,
        'user_RC': "NEED TO SET ON PROFILE PAGE",
        'user_image': user?.photoURL,
        'total_run' : 0,
      });
    } else {
      // If the user document already exists, update it with the latest information
      await userDoc.update({
        'email': user?.email,
        'user_name': user?.displayName,
        'sum_distance': 0,
        'sum_time': 0,
        'user_RC': "NEED TO SET ON PROFILE PAGE",
        'user_image': user?.photoURL,
        'total_run' : 0,
      });
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      print("로그아웃 성공!");
      notifyListeners();
    } catch (e) {
      print("로그아웃 실패: $e");
      errorMessage = "로그아웃에 실패했습니다: $e"; // 실패한 경우 오류 메시지를 설정합니다.
      notifyListeners();
    }
  }

}