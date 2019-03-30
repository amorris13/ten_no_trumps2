import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'model/scoring_prefs.dart';
import 'model/user.dart';
import 'scoring_prefs_dialog.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseAuth.instance.onAuthStateChanged.asyncExpand((user) {
          return Firestore.instance
              .collection('users')
              .document(user.uid)
              .snapshots();
        }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }

          return buildBody(context, snapshot.data);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, DocumentSnapshot userSnapshot) {
    User user = User.fromMap(userSnapshot.data ?? Map());

    var entries = <Widget>[
      ListTile(
        leading: Icon(Icons.account_circle),
        title: Text("Accounts"),
        onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
      ),
      ListTile(
        leading: Icon(Icons.assessment),
        title: Text("Scoring"),
        onTap: () => showDialog<ScoringPrefs>(
              context: context,
              builder: (context) =>
                  ScoringPrefsDialog(user.scoringPrefsNonNull),
            ).then((scoringPrefs) {
              UserBuilder userBuilder = user.toBuilder();
              userBuilder.scoringPrefs = scoringPrefs.toBuilder();
              User newUser = userBuilder.build();

              userSnapshot.reference.setData(newUser.toMap());
            }),
      ),
    ];

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 0.0),
      itemCount: entries.length,
      itemBuilder: (context, index) => entries[index],
    );
  }
}
