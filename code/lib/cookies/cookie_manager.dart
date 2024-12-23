import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A class to manage cookies using secure storage.
///
/// This class provides methods to save, retrieve, and delete cookies
/// using the `FlutterSecureStorage` package.
class CookieManager {
  /// Instance of `FlutterSecureStorage` to handle secure storage operations.
  final storage = const FlutterSecureStorage();

  /// Saves a cookie with the given [key] and [value].
  ///
  /// This method writes the cookie to secure storage.
  ///
  /// - Parameters:
  ///   - key: The key under which the cookie is stored.
  ///   - value: The value of the cookie to be stored.
  Future<void> setCookie(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  /// Retrieves a cookie with the given [key].
  ///
  /// This method reads the cookie from secure storage.
  ///
  /// - Parameter key: The key of the cookie to be retrieved.
  /// - Returns: The value of the cookie, or `null` if the cookie does not exist.
  Future<String?> getCookie(String key) async {
    return await storage.read(key: key);
  }

  /// Deletes a cookie with the given [key].
  ///
  /// This method removes the cookie from secure storage.
  ///
  /// - Parameter key: The key of the cookie to be deleted.
  Future<void> deleteCookie(String key) async {
    await storage.delete(key: key);
  }
}
