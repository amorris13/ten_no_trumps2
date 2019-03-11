// GENERATED CODE - DO NOT MODIFY BY HAND

part of scoring_prefs;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NonBiddingPointsEnum _$always = const NonBiddingPointsEnum._('always');
const NonBiddingPointsEnum _$never = const NonBiddingPointsEnum._('never');
const NonBiddingPointsEnum _$onlyWithLoss =
    const NonBiddingPointsEnum._('onlyWithLoss');

NonBiddingPointsEnum _$valueOf(String name) {
  switch (name) {
    case 'always':
      return _$always;
    case 'never':
      return _$never;
    case 'onlyWithLoss':
      return _$onlyWithLoss;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<NonBiddingPointsEnum> _$values =
    new BuiltSet<NonBiddingPointsEnum>(const <NonBiddingPointsEnum>[
  _$always,
  _$never,
  _$onlyWithLoss,
]);

Serializer<ScoringPrefs> _$scoringPrefsSerializer =
    new _$ScoringPrefsSerializer();
Serializer<NonBiddingPointsEnum> _$nonBiddingPointsEnumSerializer =
    new _$NonBiddingPointsEnumSerializer();

class _$ScoringPrefsSerializer implements StructuredSerializer<ScoringPrefs> {
  @override
  final Iterable<Type> types = const [ScoringPrefs, _$ScoringPrefs];
  @override
  final String wireName = 'ScoringPrefs';

  @override
  Iterable serialize(Serializers serializers, ScoringPrefs object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'tenTrickBonus',
      serializers.serialize(object.tenTrickBonus,
          specifiedType: const FullType(bool)),
      'nonBiddingPoints',
      serializers.serialize(object.nonBiddingPoints,
          specifiedType: const FullType(NonBiddingPointsEnum)),
    ];

    return result;
  }

  @override
  ScoringPrefs deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ScoringPrefsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'tenTrickBonus':
          result.tenTrickBonus = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'nonBiddingPoints':
          result.nonBiddingPoints = serializers.deserialize(value,
                  specifiedType: const FullType(NonBiddingPointsEnum))
              as NonBiddingPointsEnum;
          break;
      }
    }

    return result.build();
  }
}

class _$NonBiddingPointsEnumSerializer
    implements PrimitiveSerializer<NonBiddingPointsEnum> {
  @override
  final Iterable<Type> types = const <Type>[NonBiddingPointsEnum];
  @override
  final String wireName = 'NonBiddingPointsEnum';

  @override
  Object serialize(Serializers serializers, NonBiddingPointsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  NonBiddingPointsEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NonBiddingPointsEnum.valueOf(serialized as String);
}

class _$ScoringPrefs extends ScoringPrefs {
  @override
  final bool tenTrickBonus;
  @override
  final NonBiddingPointsEnum nonBiddingPoints;

  factory _$ScoringPrefs([void updates(ScoringPrefsBuilder b)]) =>
      (new ScoringPrefsBuilder()..update(updates)).build();

  _$ScoringPrefs._({this.tenTrickBonus, this.nonBiddingPoints}) : super._() {
    if (tenTrickBonus == null) {
      throw new BuiltValueNullFieldError('ScoringPrefs', 'tenTrickBonus');
    }
    if (nonBiddingPoints == null) {
      throw new BuiltValueNullFieldError('ScoringPrefs', 'nonBiddingPoints');
    }
  }

  @override
  ScoringPrefs rebuild(void updates(ScoringPrefsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoringPrefsBuilder toBuilder() => new ScoringPrefsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScoringPrefs &&
        tenTrickBonus == other.tenTrickBonus &&
        nonBiddingPoints == other.nonBiddingPoints;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, tenTrickBonus.hashCode), nonBiddingPoints.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ScoringPrefs')
          ..add('tenTrickBonus', tenTrickBonus)
          ..add('nonBiddingPoints', nonBiddingPoints))
        .toString();
  }
}

class ScoringPrefsBuilder
    implements Builder<ScoringPrefs, ScoringPrefsBuilder> {
  _$ScoringPrefs _$v;

  bool _tenTrickBonus;
  bool get tenTrickBonus => _$this._tenTrickBonus;
  set tenTrickBonus(bool tenTrickBonus) =>
      _$this._tenTrickBonus = tenTrickBonus;

  NonBiddingPointsEnum _nonBiddingPoints;
  NonBiddingPointsEnum get nonBiddingPoints => _$this._nonBiddingPoints;
  set nonBiddingPoints(NonBiddingPointsEnum nonBiddingPoints) =>
      _$this._nonBiddingPoints = nonBiddingPoints;

  ScoringPrefsBuilder();

  ScoringPrefsBuilder get _$this {
    if (_$v != null) {
      _tenTrickBonus = _$v.tenTrickBonus;
      _nonBiddingPoints = _$v.nonBiddingPoints;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScoringPrefs other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ScoringPrefs;
  }

  @override
  void update(void updates(ScoringPrefsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ScoringPrefs build() {
    final _$result = _$v ??
        new _$ScoringPrefs._(
            tenTrickBonus: tenTrickBonus, nonBiddingPoints: nonBiddingPoints);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
