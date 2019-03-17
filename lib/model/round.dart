library round;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'scoring_prefs.dart';
import 'serializers.dart';

part 'round.g.dart';

abstract class Round implements Built<Round, RoundBuilder> {
  int get numHands;
  int get teamAScore;
  int get teamBScore;
  DateTime get lastPlayed;

  bool get finished;
  @nullable
  int get winningTeam;

  @nullable
  ScoringPrefs get scoringPrefs;
  @memoized
  ScoringPrefs get scoringPrefsNonNull =>
      scoringPrefs == null ? ScoringPrefs.createDefault() : scoringPrefs;

  Round._();

  factory Round([updates(RoundBuilder b)]) = _$Round;

  Map<String, dynamic> toMap() {
    return serializers.serialize(this, specifiedType: FullType(Round))
        as Map<String, dynamic>;
  }

  static Round fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Round.serializer, map);
  }

  static Serializer<Round> get serializer => _$roundSerializer;
}
