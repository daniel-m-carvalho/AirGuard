import 'dart:convert';
import 'package:air_guard/domain/enteties/user_type.dart';
import 'package:air_guard/domain/models/user.dart';
import 'package:air_guard/repository/firestore/user_repo.dart';
import 'package:air_guard/cookies/cookie_manager.dart';
import 'package:air_guard/services/results.dart';
import 'package:air_guard/util/left.dart';
import 'package:air_guard/util/right.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// A service class that provides authentication functionality.
///
/// The `AuthService` class provides methods for logging in, registering, and logging out users.
/// It uses a `UserRepository` to interact with the user data stored in Firestore.
///
/// Methods:
/// - `Future<bool> login(String username, String password)`: Logs in a user with the given username and password.
/// - `Future<bool> register(String username, String email, String password)`: Registers a new user with the given username, email, and password.
/// - `Future<bool> logout()`: Logs out the user with the given username.
/// - `String _generateToken(String username, String email, String password)`: Generates a token for the user based on the username, email, and password.
class AuthService {
  final UserRepository _userRepository;
  final CookieManager _cookieManager = CookieManager();

  AuthService(this._userRepository);

  /// Logs in a user with the given username and password.
  /// This method logs in a user with the given username and password.
  /// It retrieves the user from Firestore by the username, and checks if the token matches the generated token based on the email and password.
  ///
  ///  Parameters:
  /// - `String username`: The username of the user.
  /// - `String password`: The password of the user.
  ///
  /// Returns:
  /// - A `Future` that resolves to a `UserResult` object representing the result of the login process.
  Future<UserResult> login(String username, String password) async {
    try {
      final user = await _userRepository.getByName(username);

      if (user != null &&
          user.token == _generateToken(username, user.email, password)) {
        await _cookieManager.setCookie('token', user.token!);
        return success(user);
      } else {
        return failure(const UserNotFound());
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error during login: $e');
      return failure(const UserNotFound());
    }
  }

  /// Registers a new user with the given username, email, and password.
  /// This method registers a new user with the given username, email, and password.
  /// It generates a random token for the user based on the email and password,
  /// and saves the new user to Firestore.
  /// If the registration is successful, the method returns true.
  /// If an error occurs during the registration process, the method returns false.
  ///
  /// Parameters:
  /// - `String username`: The username of the new user.
  /// - `String email`: The email of the new user.
  /// - `String password`: The password of the new user.
  /// - `String userType`: The type of the new user.
  ///
  /// Returns:
  /// - A `Future` that resolves to a `UserResult` object representing the result of the registration process.
  Future<UserResult> register(
      String username, String email, String password, String userType) async {
    try {
      // Validate email
      if (!_isValidEmail(email)) {
        return failure(const InvalidEmail());
      }

      // Validate password
      if (!_isValidPassword(password)) {
        return failure(const InvalidPassword());
      }

      // Check if user already exists
      User? existingUser = await _userRepository.getByName(username);
      if (existingUser != null) {
        return failure(const UserAlreadyExists());
      }

      // Generate token and create new user
      String token = _generateToken(username, email, password);
      User newUser = User(
          token: token,
          name: username,
          email: email,
          type: userTypeFromString(userType));
      await _userRepository.post(newUser);
      return success(newUser);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during registration: $e');
      return failure(const UserAlreadyExists()); // Default fallback
    }
  }

  /// Logs out the user.
  /// This method logs out the user with the given username by deleting the user's token from the cookie.
  /// If the user is successfully logged out, the method returns true.
  /// If the user is not logged in, the method returns false.
  Future<bool> logout() async {
    String? token = await _cookieManager.getCookie('token');
    if (token != null) {
      await _cookieManager.deleteCookie('token');
      return true;
    }
    return false;
  }

  /// Generates a token for the user based on the username, email, and password.
  /// This method generates a base64-encoded token for the user based on the username, email, and password.
  ///
  /// Parameters:
  /// - `String username`: The username of the user.
  /// - `String email`: The email of the user.
  /// - `String password`: The password of the user.
  String _generateToken(String username, String email, String password) {
    final input = '$username:$email:$password';
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Validates an email address.
  /// This method validates an email address by checking if it is not empty and matches a simple regex pattern.
  /// If the email address is valid, the method returns true.
  /// If the email address is invalid, the method returns false.
  bool _isValidEmail(String email) {
    // Simple regex for basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Validates a password.
  /// This method validates a password by checking if it is at least 8 characters long and contains at least one uppercase letter, one lowercase letter, one number, and one special character.
  /// If the password is valid, the method returns true.
  /// If the password is invalid, the method returns false.
  bool _isValidPassword(String password) {
    // Validate password length and complexity
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) && // at least one uppercase
        password.contains(RegExp(r'[a-z]')) && // at least one lowercase
        password.contains(RegExp(r'\d')) && // at least one number
        password.contains(RegExp(
            r'[!@#$%^&*(),.?":{}|<>]')); // at least one special character
  }
}
