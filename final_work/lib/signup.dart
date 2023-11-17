// import 'package:flutter/material.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmpasswordController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SafeArea(
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               children: <Widget>[
//                 TextFormField(
//                   validator: (value) {
//                     // Username validation
//                     final usernameRegex = RegExp(r'^(?=(?:.*[a-zA-Z]){3})(?=(?:.*\d){3})[a-zA-Z\d]*$');
//                     if (value == null || value.isEmpty || !usernameRegex.hasMatch(value)) {
//                       return 'Username is invalid';
//                     }
//                     return null;
//                   },
//                   controller: _usernameController,
//                   decoration: const InputDecoration(
//                     filled: true,
//                     labelText: 'Username',
//                   ),
//                 ),
//                 const SizedBox(height: 12.0),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(
//                     filled: true,
//                     labelText: 'Password',
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     // Password validation
//                     if (value == null || value.isEmpty ) {
//                       return 'Please enter a password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12.0),
//                 TextFormField(
//                   controller: _confirmpasswordController,
//                   decoration: const InputDecoration(
//                     filled: true,
//                     labelText: 'Confirm Password',
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     // Confirm Password validation
//                     if (value != _passwordController.text) {
//                       return 'Confirm Password doesn\'t match Password';
//                     }
//                     if (value == null || value.isEmpty ) {
//                       return 'Please enter a password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12.0),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     filled: true,
//                     labelText: 'Email Address',
//                   ),
//                   validator: (value) {
//                     // Confirm Password validation
//                     if (value == null || value.isEmpty ) {
//                       return 'Please enter Email Address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12.0),
//                 OverflowBar(
//                   alignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     ElevatedButton(
//                       child: const Text('SIGN UP'),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Processing Data')),
//                           );
//                           Navigator.pop(context);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
