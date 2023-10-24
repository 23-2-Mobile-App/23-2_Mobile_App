import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !_isValidUsername(value)) {
                    return 'Username is invalid';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Password',
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty || value != _passwordController.text) {
                    return 'Confirm Password doesn\'t match Password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _confirmPassword = value!;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Email Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context);
                    // Navigate to Sign In Page or perform further actions.
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidUsername(String username) {
    if (username.length < 6) {
      return false;
    }

    int letterCount = 0;
    int numberCount = 0;

    for (int i = 0; i < username.length; i++) {
      if (isLetter(username[i])) {
        letterCount++;
      } else if (isDigit(username[i]))  {
        numberCount++;
      }

      if (letterCount >= 3 && numberCount >= 3) {
        return true;
      }
    }

    return false;
  }

  bool isLetter(String character) {
    final RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    return letterRegExp.hasMatch(character);
  }

  bool isDigit(String character) {
    final RegExp digitRegExp = RegExp(r'[0-9]');
    return digitRegExp.hasMatch(character);
  }
}
