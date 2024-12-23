import 'package:air_guard/domain/enteties/user_type.dart';

/// Represents a user of the application.
///
/// This class is used to store information about a user of the application.
/// It contains the user's ID, name, email, and type.
///
/// Properties:
/// - `token` (String, optional): The user's authentication token.
/// - `id` (int): The user's unique identifier.
/// - `name` (String): The user's name.
/// - `email` (String): The user's email address.
/// - `type` (UserType, optional): The user's type (citizen or professional).
class User {
  final String? token;
  final String name;
  final String email;
  final UserType type;

  User({
    this.token,
    required this.name,
    required this.email,
    this.type = UserType.citizen,
  });
}
