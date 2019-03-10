library match;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'match.g.dart';

abstract class Match implements Built<Match, MatchBuilder> {
  static const int NUM_TEAMS = 2;

  // Team number 0
  Team get teamA;
  // Team number 1
  Team get teamB;
  DateTime get lastPlayed;

  Match._();

  List<Team> getTeams() {
    return [teamA, teamB];
  }

  bool isPlayerOnTeam(int teamNumber, int playerNumber) {
    return playerNumber % NUM_TEAMS == teamNumber;
  }

  Team getTeam(int teamNumber) {
    switch (teamNumber) {
      case 0:
        return teamA;
      case 1:
        return teamB;
      default:
        throw Error();
    }
  }

  Team getTeamForPlayerNumber(int playerNumber) {
    return getTeam(playerNumber % NUM_TEAMS);
  }

  String getPlayerName(int playerNumber) {
    Team team = getTeamForPlayerNumber(playerNumber);
    switch (playerNumber / NUM_TEAMS) {
      case 0:
        return team.player1;
      case 1:
        return team.player2;
      default:
        throw Error();
    }
  }

  bool hasPlayerNames() {
    return teamA.hasPlayerNames() && teamB.hasPlayerNames();
  }

  factory Match([updates(MatchBuilder b)]) = _$Match;

  Map<String, dynamic> toMap() {
    return serializers.serialize(this, specifiedType: FullType(Match))
        as Map<String, dynamic>;
  }

  static Match fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Match.serializer, map);
  }

  static Serializer<Match> get serializer => _$matchSerializer;
}

abstract class Team implements Built<Team, TeamBuilder> {
  static const int NUM_PLAYERS = 2;

  String get name;

  @nullable
  String get player1;

  @nullable
  String get player2;

  int get wins;

  Team._();

  bool hasPlayerNames() {
    return player1 != null && player2 != null;
  }

  List<String> getPlayers() {
    return [player1, player2];
  }

  String getPlayerName(int playerWithinTeamNumber) {
    switch (playerWithinTeamNumber) {
      case 0:
        return player1;
      case 1:
        return player2;
      default:
        throw Error();
    }
  }

  factory Team([updates(TeamBuilder b)]) = _$Team;

  Map<String, dynamic> toMap() {
    return serializers.serialize(this, specifiedType: FullType(Team))
        as Map<String, dynamic>;
  }

  static Team fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Team.serializer, map);
  }

  static Serializer<Team> get serializer => _$teamSerializer;
}
