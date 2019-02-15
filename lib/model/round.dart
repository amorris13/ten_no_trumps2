library round;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'round.g.dart';

abstract class Round implements Built<Round, RoundBuilder> {
  int get teamAScore;
  int get teamBScore;
  DateTime get lastPlayed;

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
