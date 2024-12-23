import 'package:air_guard/domain/models/health_measure.dart';
import 'package:air_guard/repository/serializers/serializer.dart';
import 'package:air_guard/repository/serializers/user_serializer.dart';

/// A serializer for the `HealthMeasure` class, implementing the `Serializer` interface.
/// This class provides methods to serialize and deserialize `HealthMeasure` objects.
///
/// The `HealthMeasureSerializer` uses a `UserSerializer` to handle the serialization
/// and deserialization of the `user` field within a `HealthMeasure`.
///
/// Methods:
/// - `serialize(HealthMeasure healthMeasure)`: Converts a `HealthMeasure` object into a
///   `Map<String, dynamic>`.
/// - `deserialize(Map<String, dynamic> map)`: Converts a `Map<String, dynamic>` into a
///   `HealthMeasure` object.
class HealthMeasureSerializer implements Serializer<HealthMeasure> {
  final UserSerializer _userSerializer = UserSerializer();

  /// Converts a `HealthMeasure` object into a `Map<String, dynamic>`.
  ///
  /// Parameters:
  /// - `healthMeasure`: The `HealthMeasure` object to serialize.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` representing the `HealthMeasure` object.
  @override
  Map<String, dynamic> serialize(HealthMeasure healthMeasure) {
    return {
      'id': healthMeasure.id,
      'qualityIndex': healthMeasure.qualityIndex,
      'text': healthMeasure.text,
      'user': _userSerializer.serialize(healthMeasure.user), // Serialize User
    };
  }

  /// Converts a `Map<String, dynamic>` into a `HealthMeasure` object.
  ///
  /// Parameters:
  /// - `map`: The `Map<String, dynamic>` to deserialize.
  ///
  /// Returns:
  /// - A `HealthMeasure` object representing the `Map<String, dynamic>`.
  @override
  HealthMeasure deserialize(Map<String, dynamic> map) {
    return HealthMeasure(
      id: map['id'],
      qualityIndex: map['qualityIndex'],
      text: map['text'],
      user: _userSerializer.deserialize(map['user']), // Deserialize User
    );
  }
}
