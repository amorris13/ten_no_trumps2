library match;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'match.g.dart';

abstract class Match implements Built<Match, MatchBuilder> {
  Team get teamA;
  Team get teamB;
  DateTime get lastPlayed;

  Match._();

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
  String get name;

  @nullable
  String get player1;

  @nullable
  String get player2;

  int get wins;

  Team._();
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
