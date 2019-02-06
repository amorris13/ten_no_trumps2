import 'package:cloud_firestore/cloud_firestore.dart';

class Round {
  final int teamAScore;
  final int teamBScore;

  final DocumentReference reference;

  Round(this.teamAScore, this.teamBScore, {this.reference});

  Round.fromSnapshot(DocumentSnapshot snapshot)
      : teamAScore = snapshot.data['teamA_score'],
        teamBScore = snapshot.data['teamB_score'],
        reference = snapshot.reference;

  @override
  String toString() => "Round<$teamAScore vs $teamBScore>";
}
