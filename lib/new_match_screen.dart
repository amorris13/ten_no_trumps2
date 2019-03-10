import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'match_screen.dart';
import 'model/match.dart';

class NewMatchScreen extends StatefulWidget {
  NewMatchScreen();

  @override
  _NewMatchScreenState createState() {
    return _NewMatchScreenState();
  }
}

class _NewMatchScreenState extends State<NewMatchScreen> {
  final _formKey = GlobalKey<FormState>();

  HandBuilder matchBuilder = HandBuilder();

  _NewMatchScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Match")),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Teams (Required)",
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                _teamInput("Team 1", matchBuilder.teamA),
                _teamInput("Team 2", matchBuilder.teamB),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Players (Optional)",
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                _playerInput(matchBuilder.teamA),
                _playerInput(matchBuilder.teamB),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    matchBuilder.lastPlayed = DateTime.now();
                    matchBuilder.teamA.wins = 0;
                    matchBuilder.teamB.wins = 0;

                    DocumentReference matchReference =
                        Firestore.instance.collection("matches").document();
                    matchReference.setData(matchBuilder.build().toMap());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MatchScreen(matchReference)),
                    );
                  }
                },
                child: Text('Create Team'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _teamInput(String labelText, TeamBuilder team) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: TextFormField(
          decoration: InputDecoration(labelText: labelText),
          validator: (value) {
            if (value.isEmpty) {
              return 'Required';
            }
          },
          onSaved: (String value) {
            team.name = value;
          },
        ),
      ),
    );
  }

  Expanded _playerInput(TeamBuilder team) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Player 1"),
              onSaved: (String value) {
                team.player1 = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Player 2"),
              onSaved: (String value) {
                team.player2 = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
