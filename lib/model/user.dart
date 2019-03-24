library user;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'scoring_prefs.dart';
import 'serializers.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  @nullable
  ScoringPrefs get scoringPrefs;
  @memoized
  ScoringPrefs get scoringPrefsNonNull =>
      scoringPrefs ?? ScoringPrefs.createDefault();

  User._();

  factory User([updates(UserBuilder b)]) = _$User;

  Map<String, dynamic> toMap() {
    return serializers.serialize(this, specifiedType: FullType(User))
        as Map<String, dynamic>;
  }

  static User fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(User.serializer, map ?? Map());
  }

  static Serializer<User> get serializer => _$userSerializer;
}
