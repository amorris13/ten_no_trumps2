library scoring_prefs;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'scoring_prefs.g.dart';

abstract class ScoringPrefs
    implements Built<ScoringPrefs, ScoringPrefsBuilder> {
  bool get tenTrickBonus;
  NonBiddingPointsEnum get nonBiddingPoints;

  ScoringPrefs._();

  factory ScoringPrefs([updates(ScoringPrefsBuilder b)]) = _$ScoringPrefs;

  Map<String, dynamic> toMap() {
    return serializers.serialize(this, specifiedType: FullType(ScoringPrefs))
        as Map<String, dynamic>;
  }

  static ScoringPrefs fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(ScoringPrefs.serializer, map);
  }

  static Serializer<ScoringPrefs> get serializer => _$scoringPrefsSerializer;
}

class NonBiddingPointsEnum extends EnumClass {
  static Serializer<NonBiddingPointsEnum> get serializer =>
      _$nonBiddingPointsEnumSerializer;

  static const NonBiddingPointsEnum always = _$always;
  static const NonBiddingPointsEnum never = _$never;
  static const NonBiddingPointsEnum onlyWithLoss = _$onlyWithLoss;

  const NonBiddingPointsEnum._(String name) : super(name);

  static BuiltSet<NonBiddingPointsEnum> get values => _$values;
  static NonBiddingPointsEnum valueOf(String name) => _$valueOf(name);
}
