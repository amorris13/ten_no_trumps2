import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '500 Scorer',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('500 Scorer')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('matches').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final match = Match.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text("${match.teamA.name} vs ${match.teamB.name}"),
          onTap: () => print(match),
        ),
      ),
    );
  }
}

class Match {
  final Team teamA;
  final Team teamB;
  final DateTime lastPlayed;

  final DocumentReference reference;

  Match(this.teamA, this.teamB, this.lastPlayed, {this.reference});

  Match.fromSnapshot(DocumentSnapshot snapshot)
      : teamA = Team.fromMap(snapshot.data['teamA']),
        teamB = Team.fromMap(snapshot.data['teamB']),
        lastPlayed = snapshot.data['last_played'],
        reference = snapshot.reference;

  @override
  String toString() => "Match<$teamA vs $teamB, last played: $lastPlayed>";
}

class Team {
  final String name;
  final String player1;
  final String player2;
  final int wins;

  Team(this.name, this.player1, this.player2) : wins = 0;

  Team.fromMap(Map map)
      : name = map["name"],
        player1 = map["player1"],
        player2 = map["player2"],
        wins = map["wins"];

  @override
  String toString() => "Team<$name:$player1,$player2. wins: $wins>";
}
