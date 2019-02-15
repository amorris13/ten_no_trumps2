class Round {
  final int teamAScore;
  final int teamBScore;
  final DateTime lastPlayed;

  Round(this.teamAScore, this.teamBScore, this.lastPlayed);

  Round.fromMap(Map map)
      : teamAScore = map['teamA_score'],
        teamBScore = map['teamB_score'],
        lastPlayed = map['last_played'];

  @override
  String toString() => "Round<$teamAScore vs $teamBScore>";
}
