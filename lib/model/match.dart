import 'package:cloud_firestore/cloud_firestore.dart';

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
