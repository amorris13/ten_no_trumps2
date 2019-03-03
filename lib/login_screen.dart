import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    signIn().then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user)),
      );
    });
  }

  Future<FirebaseUser> signIn() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      return user;
    }

    user = await _auth.signInAnonymously();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
