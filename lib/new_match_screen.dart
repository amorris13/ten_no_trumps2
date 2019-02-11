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

  NewMatch newMatch = NewMatch();

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
                _teamInput("Team 1", newMatch.teamA),
                _teamInput("Team 2", newMatch.teamB),
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
                _playerInput(newMatch.teamA),
                _playerInput(newMatch.teamB),
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
                    Future<DocumentReference> addMatch = Firestore.instance
                        .collection("matches")
                        .add(newMatch.toMap());
                    Future<Match> match = addMatch.then((matchReference) =>
                        matchReference
                            .snapshots()
                            .map((snapshot) => Match.fromSnapshot(snapshot))
                            .first);
                    match.then((match) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchScreen(match)),
                        ));
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

  Expanded _teamInput(String labelText, NewTeam team) {
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

  Expanded _playerInput(NewTeam team) {
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

class NewMatch {
  NewTeam teamA = NewTeam();
  NewTeam teamB = NewTeam();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["teamA"] = teamA.toMap();
    map["teamB"] = teamB.toMap();
    map["last_played"] = DateTime.now();
    return map;
  }

  @override
  String toString() => "NewMatch<$teamA vs $teamB>";
}

class NewTeam {
  String name;
  String player1;
  String player2;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["name"] = name;
    map["wins"] = 0;
    if (player1 != null && player2 != null) {
      map["player1"] = player1;
      map["player2"] = player2;
    }
    return map;
  }

  @override
  String toString() => "NewTeam<$name:$player1,$player2>";
}
