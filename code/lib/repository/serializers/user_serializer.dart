import 'package:air_guard/domain/enteties/user_type.dart';
import 'package:air_guard/domain/models/user.dart';
import 'package:air_guard/repository/serializers/serializer.dart';

/// A serializer for the `User` class, implementing the `Serializer` interface.
/// This class provides methods to serialize and deserialize `User` objects.
///
/// Methods:
/// - `serialize(User user)`: Converts a `User` object into a `Map<String, dynamic>`.
/// - `deserialize(Map<String, dynamic> map)`: Converts a `Map<String, dynamic>` into a `User` object.
class UserSerializer implements Serializer<User> {
  /// Converts a `User` object into a `Map<String, dynamic>`.
  /// The `User` object is converted into a map with the following
  /// key-value pairs:
  /// - `token`: The user's token.
  /// - `id`: The user's ID.
  /// - `name`: The user's name.
  /// - `email`: The user's email.
  /// - `type`: The user's type, converted to a string.
  ///
  /// Parameters:
  /// - `user`: The `User` object to serialize.
  ///
  /// Returns:
  /// A `Map<String, dynamic>` representing the `User` object.
  @override
  Map<String, dynamic> serialize(User user) {
    return {
      'token': user.token,
      'name': user.name,
      'email': user.email,
      'type': userTypeToString(user.type), // Convert UserType to string
    };
  }

  /// Converts a `Map<String, dynamic>` into a `User` object.
  /// The map is converted into a `User` object with the following
  /// key-value pairs:
  /// - `id`: The user's ID.
  /// - `name`: The user's name.
  /// - `email`: The user's email.
  /// - `type`: The user's type, converted to a `UserType` enum.
  /// The `type` value is converted from a string to a `UserType` enum.
  ///
  /// Parameters:
  /// - `map`: The `Map<String, dynamic>` to deserialize.
  ///
  /// Returns:
  /// A `User` object representing the `Map<String, dynamic>`.
  @override
  User deserialize(Map<String, dynamic> map) {
    return User(
      token: map['token'],
      name: map['name'],
      email: map['email'],
      type: userTypeFromString(map['type']),
    );
  }
}
