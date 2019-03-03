// GENERATED CODE - DO NOT MODIFY BY HAND

part of hand;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Hand> _$handSerializer = new _$HandSerializer();

class _$HandSerializer implements StructuredSerializer<Hand> {
  @override
  final Iterable<Type> types = const [Hand, _$Hand];
  @override
  final String wireName = 'Hand';

  @override
  Iterable serialize(Serializers serializers, Hand object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'bid',
      serializers.serialize(object.bid, specifiedType: const FullType(String)),
      'biddingTeam',
      serializers.serialize(object.biddingTeam,
          specifiedType: const FullType(int)),
      'pointsTeamA',
      serializers.serialize(object.pointsTeamA,
          specifiedType: const FullType(int)),
      'cumPointsTeamA',
      serializers.serialize(object.cumPointsTeamA,
          specifiedType: const FullType(int)),
      'pointsTeamB',
      serializers.serialize(object.pointsTeamB,
          specifiedType: const FullType(int)),
      'cumPointsTeamB',
      serializers.serialize(object.cumPointsTeamB,
          specifiedType: const FullType(int)),
      'tricksWon',
      serializers.serialize(object.tricksWon,
          specifiedType: const FullType(int)),
    ];
    if (object.biddingPlayer != null) {
      result
        ..add('biddingPlayer')
        ..add(serializers.serialize(object.biddingPlayer,
            specifiedType: const FullType(int)));
    }
    if (object.dealer != null) {
      result
        ..add('dealer')
        ..add(serializers.serialize(object.dealer,
            specifiedType: const FullType(int)));
    }

    return result;
  }

  @override
  Hand deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HandBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'bid':
          result.bid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'biddingPlayer':
          result.biddingPlayer = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'biddingTeam':
          result.biddingTeam = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'dealer':
          result.dealer = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'pointsTeamA':
          result.pointsTeamA = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'cumPointsTeamA':
          result.cumPointsTeamA = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'pointsTeamB':
          result.pointsTeamB = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'cumPointsTeamB':
          result.cumPointsTeamB = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'tricksWon':
          result.tricksWon = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Hand extends Hand {
  @override
  final String bid;
  @override
  final int biddingPlayer;
  @override
  final int biddingTeam;
  @override
  final int dealer;
  @override
  final int pointsTeamA;
  @override
  final int cumPointsTeamA;
  @override
  final int pointsTeamB;
  @override
  final int cumPointsTeamB;
  @override
  final int tricksWon;
  Bid __actualBid;

  factory _$Hand([void updates(HandBuilder b)]) =>
      (new HandBuilder()..update(updates)).build();

  _$Hand._(
      {this.bid,
      this.biddingPlayer,
      this.biddingTeam,
      this.dealer,
      this.pointsTeamA,
      this.cumPointsTeamA,
      this.pointsTeamB,
      this.cumPointsTeamB,
      this.tricksWon})
      : super._() {
    if (bid == null) {
      throw new BuiltValueNullFieldError('Hand', 'bid');
    }
    if (biddingTeam == null) {
      throw new BuiltValueNullFieldError('Hand', 'biddingTeam');
    }
    if (pointsTeamA == null) {
      throw new BuiltValueNullFieldError('Hand', 'pointsTeamA');
    }
    if (cumPointsTeamA == null) {
      throw new BuiltValueNullFieldError('Hand', 'cumPointsTeamA');
    }
    if (pointsTeamB == null) {
      throw new BuiltValueNullFieldError('Hand', 'pointsTeamB');
    }
    if (cumPointsTeamB == null) {
      throw new BuiltValueNullFieldError('Hand', 'cumPointsTeamB');
    }
    if (tricksWon == null) {
      throw new BuiltValueNullFieldError('Hand', 'tricksWon');
    }
  }

  @override
  Bid get actualBid => __actualBid ??= super.actualBid;

  @override
  Hand rebuild(void updates(HandBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  HandBuilder toBuilder() => new HandBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Hand &&
        bid == other.bid &&
        biddingPlayer == other.biddingPlayer &&
        biddingTeam == other.biddingTeam &&
        dealer == other.dealer &&
        pointsTeamA == other.pointsTeamA &&
        cumPointsTeamA == other.cumPointsTeamA &&
        pointsTeamB == other.pointsTeamB &&
        cumPointsTeamB == other.cumPointsTeamB &&
        tricksWon == other.tricksWon;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc($jc(0, bid.hashCode),
                                    biddingPlayer.hashCode),
                                biddingTeam.hashCode),
                            dealer.hashCode),
                        pointsTeamA.hashCode),
                    cumPointsTeamA.hashCode),
                pointsTeamB.hashCode),
            cumPointsTeamB.hashCode),
        tricksWon.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Hand')
          ..add('bid', bid)
          ..add('biddingPlayer', biddingPlayer)
          ..add('biddingTeam', biddingTeam)
          ..add('dealer', dealer)
          ..add('pointsTeamA', pointsTeamA)
          ..add('cumPointsTeamA', cumPointsTeamA)
          ..add('pointsTeamB', pointsTeamB)
          ..add('cumPointsTeamB', cumPointsTeamB)
          ..add('tricksWon', tricksWon))
        .toString();
  }
}

class HandBuilder implements Builder<Hand, HandBuilder> {
  _$Hand _$v;

  String _bid;
  String get bid => _$this._bid;
  set bid(String bid) => _$this._bid = bid;

  int _biddingPlayer;
  int get biddingPlayer => _$this._biddingPlayer;
  set biddingPlayer(int biddingPlayer) => _$this._biddingPlayer = biddingPlayer;

  int _biddingTeam;
  int get biddingTeam => _$this._biddingTeam;
  set biddingTeam(int biddingTeam) => _$this._biddingTeam = biddingTeam;

  int _dealer;
  int get dealer => _$this._dealer;
  set dealer(int dealer) => _$this._dealer = dealer;

  int _pointsTeamA;
  int get pointsTeamA => _$this._pointsTeamA;
  set pointsTeamA(int pointsTeamA) => _$this._pointsTeamA = pointsTeamA;

  int _cumPointsTeamA;
  int get cumPointsTeamA => _$this._cumPointsTeamA;
  set cumPointsTeamA(int cumPointsTeamA) =>
      _$this._cumPointsTeamA = cumPointsTeamA;

  int _pointsTeamB;
  int get pointsTeamB => _$this._pointsTeamB;
  set pointsTeamB(int pointsTeamB) => _$this._pointsTeamB = pointsTeamB;

  int _cumPointsTeamB;
  int get cumPointsTeamB => _$this._cumPointsTeamB;
  set cumPointsTeamB(int cumPointsTeamB) =>
      _$this._cumPointsTeamB = cumPointsTeamB;

  int _tricksWon;
  int get tricksWon => _$this._tricksWon;
  set tricksWon(int tricksWon) => _$this._tricksWon = tricksWon;

  HandBuilder();

  HandBuilder get _$this {
    if (_$v != null) {
      _bid = _$v.bid;
      _biddingPlayer = _$v.biddingPlayer;
      _biddingTeam = _$v.biddingTeam;
      _dealer = _$v.dealer;
      _pointsTeamA = _$v.pointsTeamA;
      _cumPointsTeamA = _$v.cumPointsTeamA;
      _pointsTeamB = _$v.pointsTeamB;
      _cumPointsTeamB = _$v.cumPointsTeamB;
      _tricksWon = _$v.tricksWon;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Hand other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Hand;
  }

  @override
  void update(void updates(HandBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Hand build() {
    final _$result = _$v ??
        new _$Hand._(
            bid: bid,
            biddingPlayer: biddingPlayer,
            biddingTeam: biddingTeam,
            dealer: dealer,
            pointsTeamA: pointsTeamA,
            cumPointsTeamA: cumPointsTeamA,
            pointsTeamB: pointsTeamB,
            cumPointsTeamB: cumPointsTeamB,
            tricksWon: tricksWon);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
