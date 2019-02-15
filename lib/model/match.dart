class Match {
  final Team teamA;
  final Team teamB;
  final DateTime lastPlayed;

  Match(this.teamA, this.teamB, this.lastPlayed);

  Match.fromMap(Map map)
      : teamA = Team.fromMap(map['teamA']),
        teamB = Team.fromMap(map['teamB']),
        lastPlayed = map['last_played'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["teamA"] = teamA.toMap();
    map["teamB"] = teamB.toMap();
    map["last_played"] = DateTime.now();
    return map;
  }

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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["name"] = name;
    map["wins"] = wins;
    if (player1 != null && player2 != null) {
      map["player1"] = player1;
      map["player2"] = player2;
    }
    return map;
  }

  @override
  String toString() => "Team<$name:$player1,$player2. wins: $wins>";
}
