// GENERATED CODE - DO NOT MODIFY BY HAND

part of match;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Match> _$matchSerializer = new _$MatchSerializer();
Serializer<Team> _$teamSerializer = new _$TeamSerializer();

class _$MatchSerializer implements StructuredSerializer<Match> {
  @override
  final Iterable<Type> types = const [Match, _$Match];
  @override
  final String wireName = 'Match';

  @override
  Iterable serialize(Serializers serializers, Match object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'teamA',
      serializers.serialize(object.teamA, specifiedType: const FullType(Team)),
      'teamB',
      serializers.serialize(object.teamB, specifiedType: const FullType(Team)),
      'lastPlayed',
      serializers.serialize(object.lastPlayed,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  Match deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MatchBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'teamA':
          result.teamA.replace(serializers.deserialize(value,
              specifiedType: const FullType(Team)) as Team);
          break;
        case 'teamB':
          result.teamB.replace(serializers.deserialize(value,
              specifiedType: const FullType(Team)) as Team);
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

class _$TeamSerializer implements StructuredSerializer<Team> {
  @override
  final Iterable<Type> types = const [Team, _$Team];
  @override
  final String wireName = 'Team';

  @override
  Iterable serialize(Serializers serializers, Team object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'wins',
      serializers.serialize(object.wins, specifiedType: const FullType(int)),
    ];
    if (object.player1 != null) {
      result
        ..add('player1')
        ..add(serializers.serialize(object.player1,
            specifiedType: const FullType(String)));
    }
    if (object.player2 != null) {
      result
        ..add('player2')
        ..add(serializers.serialize(object.player2,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Team deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TeamBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'player1':
          result.player1 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'player2':
          result.player2 = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'wins':
          result.wins = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Match extends Match {
  @override
  final Team teamA;
  @override
  final Team teamB;
  @override
  final DateTime lastPlayed;

  factory _$Match([void updates(MatchBuilder b)]) =>
      (new MatchBuilder()..update(updates)).build();

  _$Match._({this.teamA, this.teamB, this.lastPlayed}) : super._() {
    if (teamA == null) {
      throw new BuiltValueNullFieldError('Match', 'teamA');
    }
    if (teamB == null) {
      throw new BuiltValueNullFieldError('Match', 'teamB');
    }
    if (lastPlayed == null) {
      throw new BuiltValueNullFieldError('Match', 'lastPlayed');
    }
  }

  @override
  Match rebuild(void updates(MatchBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  MatchBuilder toBuilder() => new MatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Match &&
        teamA == other.teamA &&
        teamB == other.teamB &&
        lastPlayed == other.lastPlayed;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, teamA.hashCode), teamB.hashCode), lastPlayed.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Match')
          ..add('teamA', teamA)
          ..add('teamB', teamB)
          ..add('lastPlayed', lastPlayed))
        .toString();
  }
}

class MatchBuilder implements Builder<Match, MatchBuilder> {
  _$Match _$v;

  TeamBuilder _teamA;
  TeamBuilder get teamA => _$this._teamA ??= new TeamBuilder();
  set teamA(TeamBuilder teamA) => _$this._teamA = teamA;

  TeamBuilder _teamB;
  TeamBuilder get teamB => _$this._teamB ??= new TeamBuilder();
  set teamB(TeamBuilder teamB) => _$this._teamB = teamB;

  DateTime _lastPlayed;
  DateTime get lastPlayed => _$this._lastPlayed;
  set lastPlayed(DateTime lastPlayed) => _$this._lastPlayed = lastPlayed;

  MatchBuilder();

  MatchBuilder get _$this {
    if (_$v != null) {
      _teamA = _$v.teamA?.toBuilder();
      _teamB = _$v.teamB?.toBuilder();
      _lastPlayed = _$v.lastPlayed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Match other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Match;
  }

  @override
  void update(void updates(MatchBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Match build() {
    _$Match _$result;
    try {
      _$result = _$v ??
          new _$Match._(
              teamA: teamA.build(),
              teamB: teamB.build(),
              lastPlayed: lastPlayed);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'teamA';
        teamA.build();
        _$failedField = 'teamB';
        teamB.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Match', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Team extends Team {
  @override
  final String name;
  @override
  final String player1;
  @override
  final String player2;
  @override
  final int wins;

  factory _$Team([void updates(TeamBuilder b)]) =>
      (new TeamBuilder()..update(updates)).build();

  _$Team._({this.name, this.player1, this.player2, this.wins}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('Team', 'name');
    }
    if (wins == null) {
      throw new BuiltValueNullFieldError('Team', 'wins');
    }
  }

  @override
  Team rebuild(void updates(TeamBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TeamBuilder toBuilder() => new TeamBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Team &&
        name == other.name &&
        player1 == other.player1 &&
        player2 == other.player2 &&
        wins == other.wins;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, name.hashCode), player1.hashCode), player2.hashCode),
        wins.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Team')
          ..add('name', name)
          ..add('player1', player1)
          ..add('player2', player2)
          ..add('wins', wins))
        .toString();
  }
}

class TeamBuilder implements Builder<Team, TeamBuilder> {
  _$Team _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _player1;
  String get player1 => _$this._player1;
  set player1(String player1) => _$this._player1 = player1;

  String _player2;
  String get player2 => _$this._player2;
  set player2(String player2) => _$this._player2 = player2;

  int _wins;
  int get wins => _$this._wins;
  set wins(int wins) => _$this._wins = wins;

  TeamBuilder();

  TeamBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _player1 = _$v.player1;
      _player2 = _$v.player2;
      _wins = _$v.wins;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Team other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Team;
  }

  @override
  void update(void updates(TeamBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Team build() {
    final _$result = _$v ??
        new _$Team._(
            name: name, player1: player1, player2: player2, wins: wins);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
