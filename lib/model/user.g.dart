// GENERATED CODE - DO NOT MODIFY BY HAND

part of user;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<User> _$userSerializer = new _$UserSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable serialize(Serializers serializers, User object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.scoringPrefs != null) {
      result
        ..add('scoringPrefs')
        ..add(serializers.serialize(object.scoringPrefs,
            specifiedType: const FullType(ScoringPrefs)));
    }

    return result;
  }

  @override
  User deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'scoringPrefs':
          result.scoringPrefs.replace(serializers.deserialize(value,
              specifiedType: const FullType(ScoringPrefs)) as ScoringPrefs);
          break;
      }
    }

    return result.build();
  }
}

class _$User extends User {
  @override
  final ScoringPrefs scoringPrefs;
  ScoringPrefs __scoringPrefsNonNull;

  factory _$User([void updates(UserBuilder b)]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._({this.scoringPrefs}) : super._();

  @override
  ScoringPrefs get scoringPrefsNonNull =>
      __scoringPrefsNonNull ??= super.scoringPrefsNonNull;

  @override
  User rebuild(void updates(UserBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User && scoringPrefs == other.scoringPrefs;
  }

  @override
  int get hashCode {
    return $jf($jc(0, scoringPrefs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('scoringPrefs', scoringPrefs))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  ScoringPrefsBuilder _scoringPrefs;
  ScoringPrefsBuilder get scoringPrefs =>
      _$this._scoringPrefs ??= new ScoringPrefsBuilder();
  set scoringPrefs(ScoringPrefsBuilder scoringPrefs) =>
      _$this._scoringPrefs = scoringPrefs;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _scoringPrefs = _$v.scoringPrefs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void updates(UserBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    _$User _$result;
    try {
      _$result = _$v ?? new _$User._(scoringPrefs: _scoringPrefs?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'scoringPrefs';
        _scoringPrefs?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
