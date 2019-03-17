import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StreamBuilder<FirebaseUser>(
        stream: _auth.onAuthStateChanged,
        builder: (context, snapshot) {
          return buildWidget(context, snapshot.data);
        },
      ),
    );
  }

  Widget buildWidget(BuildContext context, FirebaseUser currentUser) {
    var navigateToHomeScreen = (user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    };

    var signInButtons = <Widget>[];
    if (currentUser == null) {
      signInButtons.add(RaisedButton(
        onPressed: () {
          _auth
              .signInAnonymously()
              .then(navigateToHomeScreen)
              .catchError((e) => print(e));
        },
        child: Text("Sign in Anonymously"),
      ));
    }

    if (currentUser.providerData
        .where(
            (userInfo) => userInfo.providerId == GoogleAuthProvider.providerId)
        .isNotEmpty) {
      signInButtons.add(RaisedButton(
        onPressed: null,
        child: Text("Already Signed In With Google"),
      ));
    } else {
      signInButtons.add(RaisedButton(
        onPressed: () {
          _handleGoogleSignIn(currentUser)
              .then(navigateToHomeScreen)
              .catchError((e) => print(e));
        },
        child: Text("Sign in with Google"),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: signInButtons,
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleGoogleSignIn(FirebaseUser currentUser) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final FirebaseUser user = await _auth.linkWithCredential(credential);
      return user;
    } catch (e) {
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      // TODO: reconcile existing user with this user.
      return user;
    }
  }
}
