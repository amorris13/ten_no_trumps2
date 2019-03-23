import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import 'sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StreamBuilder<SignInState>(
        stream: Observable.combineLatest2(
            Observable(_auth.onAuthStateChanged).startWith(null),
            Observable(_googleSignIn.onCurrentUserChanged).startWith(null),
            (firebaseUser, googleSignInAccount) =>
                SignInState(firebaseUser, googleSignInAccount)),
        builder: (context, snapshot) {
          return buildWidget(context, snapshot.data);
        },
      ),
    );
  }

  Widget buildWidget(BuildContext context, SignInState signInState) {
    FirebaseUser currentUser = signInState?.firebaseUser;

    var signInButtons = <Widget>[];
    if (currentUser == null) {
      signInButtons.add(SignInButton(
        Colors.grey[300],
        "Continue without signing in",
        null,
        () {
          return _auth.signInAnonymously().catchError((e) => print(e));
        },
      ));
    }

    if (currentUser != null &&
        currentUser.providerData
            .where((userInfo) =>
                userInfo.providerId == GoogleAuthProvider.providerId)
            .isNotEmpty) {
      signInButtons.add(googleButton(
        "Signed in with Google",
        onPressed: null,
      ));
    } else {
      signInButtons.add(googleButton(
        "Sign in with Google",
        onPressed: () {
          return _handleGoogleSignIn(currentUser).catchError((e) => print(e));
        },
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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

  SignInButton googleButton(String label, {VoidCallback onPressed}) {
    return SignInButton(
        Colors.white, label, Image.asset('assets/google-logo.png'), onPressed);
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

class SignInState {
  final FirebaseUser firebaseUser;
  final GoogleSignInAccount googleSignInAccount;

  SignInState(this.firebaseUser, this.googleSignInAccount);
}
