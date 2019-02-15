// GENERATED CODE - DO NOT MODIFY BY HAND

part of round;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

Serializer<Round> _$roundSerializer = new _$RoundSerializer();

class _$RoundSerializer implements StructuredSerializer<Round> {
  @override
  final Iterable<Type> types = const [Round, _$Round];
  @override
  final String wireName = 'Round';

  @override
  Iterable serialize(Serializers serializers, Round object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'teamAScore',
      serializers.serialize(object.teamAScore,
          specifiedType: const FullType(int)),
      'teamBScore',
      serializers.serialize(object.teamBScore,
          specifiedType: const FullType(int)),
      'lastPlayed',
      serializers.serialize(object.lastPlayed,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  Round deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RoundBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'teamAScore':
          result.teamAScore = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'teamBScore':
          result.teamBScore = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'lastPlayed':
          result.lastPlayed = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$Round extends Round {
  @override
  final int teamAScore;
  @override
  final int teamBScore;
  @override
  final DateTime lastPlayed;

  factory _$Round([void updates(RoundBuilder b)]) =>
      (new RoundBuilder()..update(updates)).build();

  _$Round._({this.teamAScore, this.teamBScore, this.lastPlayed}) : super._() {
    if (teamAScore == null) {
      throw new BuiltValueNullFieldError('Round', 'teamAScore');
    }
    if (teamBScore == null) {
      throw new BuiltValueNullFieldError('Round', 'teamBScore');
    }
    if (lastPlayed == null) {
      throw new BuiltValueNullFieldError('Round', 'lastPlayed');
    }
  }

  @override
  Round rebuild(void updates(RoundBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  RoundBuilder toBuilder() => new RoundBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Round &&
        teamAScore == other.teamAScore &&
        teamBScore == other.teamBScore &&
        lastPlayed == other.lastPlayed;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, teamAScore.hashCode), teamBScore.hashCode),
        lastPlayed.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Round')
          ..add('teamAScore', teamAScore)
          ..add('teamBScore', teamBScore)
          ..add('lastPlayed', lastPlayed))
        .toString();
  }
}

class RoundBuilder implements Builder<Round, RoundBuilder> {
  _$Round _$v;

  int _teamAScore;
  int get teamAScore => _$this._teamAScore;
  set teamAScore(int teamAScore) => _$this._teamAScore = teamAScore;

  int _teamBScore;
  int get teamBScore => _$this._teamBScore;
  set teamBScore(int teamBScore) => _$this._teamBScore = teamBScore;

  DateTime _lastPlayed;
  DateTime get lastPlayed => _$this._lastPlayed;
  set lastPlayed(DateTime lastPlayed) => _$this._lastPlayed = lastPlayed;

  RoundBuilder();

  RoundBuilder get _$this {
    if (_$v != null) {
      _teamAScore = _$v.teamAScore;
      _teamBScore = _$v.teamBScore;
      _lastPlayed = _$v.lastPlayed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Round other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Round;
  }

  @override
  void update(void updates(RoundBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Round build() {
    final _$result = _$v ??
        new _$Round._(
            teamAScore: teamAScore,
            teamBScore: teamBScore,
            lastPlayed: lastPlayed);
    replace(_$result);
    return _$result;
  }
}
