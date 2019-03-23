library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'hand.dart';
import 'match.dart';
import 'round.dart';
import 'scoring_prefs.dart';

part 'serializers.g.dart';

/// Collection of generated serializers for the built_value chat example.
@SerializersFor(const [
  Match,
  Team,
  Round,
  Hand,
  ScoringPrefs,
  NonBiddingPointsEnum,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addBuilderFactory(
          // add this builder factory
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..add(DateTimeSerializer()))
    .build();

///A Serializer which does basically "nothing".
/// It is used, as a DateTime returned by Firestore is ALREADY a DateTime Object
/// and not just "data" which has to be deserialized into a DateTime.
class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType: FullType.unspecified}) {
    return dateTime;
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType: FullType.unspecified}) {
    return serialized as DateTime;
  }
}
