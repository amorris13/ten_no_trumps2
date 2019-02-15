library hand;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'bid.dart';
import 'serializers.dart';

part 'hand.g.dart';

abstract class Hand implements Built<Hand, HandBuilder> {
  String get bid;
  @memoized
  Bid get actualBid => Bid.bidsMap[bid];

  @nullable
  int get biddingPlayer;
  int get biddingTeam;
  @nullable
  int get dealer;
  int get pointsTeamA;
  int get pointsTeamB;
  int get tricksWon;

  Hand._();

  factory Hand([updates(HandBuilder b)]) = _$Hand;

  Map<String, dynamic> toMap() {
    return serializers.serialize(this, specifiedType: FullType(Hand))
        as Map<String, dynamic>;
  }

  static Hand fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Hand.serializer, map);
  }

  static Serializer<Hand> get serializer => _$handSerializer;
}
