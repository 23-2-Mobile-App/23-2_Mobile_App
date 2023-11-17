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

  Future<bool> signInWithGoogle() async {
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

      // Check if the user document exists, if not, create it
      await _createOrUpdateUserDocument(user);

      print("구글 로그인 성공! 사용자 ID: ${user?.uid}");
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "구글 로그인에 실패했습니다: $e";
      return false;
    }
  }


  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();

      // Check if the user document exists, if not, create it
      await _createOrUpdateAnoDocument(currentUser);

      print("익명 로그인 성공!");
      notifyListeners();
    } catch (e) {
      print("익명 로그인 실패: $e");
      errorMessage = "구글 로그인에 실패했습니다: $e";
    }
  }

  Future<void> _createOrUpdateAnoDocument(User? user) async {
    try {
      if (user?.uid == null || user!.uid.isEmpty) {
        // 사용자 UID가 null이거나 비어 있는 경우 처리
        print("사용자 UID가 null 또는 비어 있습니다.");
        return;
      }

      final userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);

      if (!(await userDoc.get()).exists) {
        // 사용자 문서가 없으면 초기 값으로 생성
        await userDoc.set({
          'uid': user.uid,
          'status_message': "I promise to take the test honestly before GOD..",
        });
        await userDoc.collection('wish_list').add({
          'item': 'default_item',
        });
      } else {
        // 사용자 문서가 이미 존재하면 최신 정보로 업데이트
        // 업데이트하기 전에 이메일과 이름이 존재하는지 확인
        if (user.email != null && user.displayName != null) {
          await userDoc.update({
            'email': user.email,
            'name': user.displayName,
          });
        }
      }
      notifyListeners();
    } catch (e) {
      // 예외 처리: 오류 메시지 출력 또는 적절한 조치 수행
      print("_createOrUpdateAnoDocument에서 오류 발생: $e");
    }
  }

  Future<void> _createOrUpdateUserDocument(User? user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);

    if (!(await userDoc.get()).exists) {
      // If the user document doesn't exist, create it with initial values
      await userDoc.set({
        'uid': user?.uid,
        'email': user?.email,
        'name': user?.displayName,
        'status_message': "I promise to take the test honestly before GOD.",
      });
      await userDoc.collection('wish_list').add({
      });
    } else {
      // If the user document already exists, update it with the latest information
      await userDoc.update({
        'email': user?.email,
        'name': user?.displayName,
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