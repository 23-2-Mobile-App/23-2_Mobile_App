// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
// import 'model/model_auth.dart';
// import 'package:rive/rive.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//
//   Artboard? riveArtboard;
//   SMIBool? isDance;
//   SMITrigger? isLookUp;
//   final FirebaseAuthProvider _authProvider = FirebaseAuthProvider();
//
//   @override
//   void initState() {
//     super.initState();
//     rootBundle.load('assets/dash_flutter_muscot.riv').then(
//           (data) async {
//         try {
//           final file = RiveFile.import(data);
//           final artboard = file.mainArtboard;
//           var controller =
//           StateMachineController.fromArtboard(artboard, 'birb');
//           if (controller != null) {
//             artboard.addController(controller);
//             isDance = controller.findSMI('dance');
//             isLookUp = controller.findSMI('look up');
//           }
//           setState(() => riveArtboard = artboard);
//         } catch (e) {
//           print(e);
//         }
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xFF01C1FD),
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           children: <Widget>[
//             const SizedBox(height: 80.0),
//             Column(
//               children: <Widget>[
//                 Text(
//                   "Kupyer Running Club",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 30.0, // 원하는 폰트 크기로 조정
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 // SizedBox(height: 200,),
//                 Container(
//                   width: 200,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       bool success = await _authProvider.signInWithGoogle();
//                       if (success) {
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     child: Text('GOOGLE'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
