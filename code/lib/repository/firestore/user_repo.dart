import 'package:air_guard/repository/repository.dart';
import 'package:air_guard/repository/serializers/user_serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:air_guard/domain/models/user.dart';
import 'package:flutter/foundation.dart';

/// A repository class for managing `User` objects in Firestore.
///
/// This class provides methods to perform CRUD (Create, Read, Update, Delete)
/// operations on `User` objects stored in a Firestore collection.
///
/// The `UserRepository` class extends the `Repository` class with `User` and `Uuid`
/// as the type parameters.
///
/// Properties:
/// - `FirebaseFirestore _firestore`: An instance of `FirebaseFirestore` to interact with Firestore.
/// - `UserSerializer _serializer`: An instance of `UserSerializer` to serialize and deserialize `User` objects.
/// - `String collectionPath`: The path of the Firestore collection where `User` objects are stored.
///
/// Methods:
/// - `Future<User?> get(Uuid id)`: Retrieves a single `User` by its ID.
/// - `Future<void> delete(Uuid id)`: Deletes a `User` by its ID.
/// - `Future<void> post(User value)`: Adds a new `User`.
/// - `Future<void> put(Uuid id, User value)`: Updates an existing `User` by its ID.
/// - `String _getFileName(int id)`: Generates a file name for a `User` based on its ID.

class UserRepository extends Repository<User, String> {
  String _getFileName(String name) => getFileName('user', name);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserSerializer _serializer = UserSerializer();
  final String collectionPath = 'users';

  /// Retrieves a single `User` by its ID.
  /// This method retrieves a single `User` object from Firestore by its ID.
  ///
  /// Parameters:
  /// - `Uuid id`: The ID of the `User` to retrieve.
  ///
  /// Returns:
  /// - A `Future` that resolves to the `User` object with the given ID.
  /// - If no `User` is found with the given ID, the `Future` resolves to `null`.
  @override
  Future<User?> get(String token) async {
    try {
      return await _firestore
          .collection(collectionPath)
          .get()
          .then((querySnapshot) {
        // Filter documents to find the one with token == id
        return _serializer.deserialize(querySnapshot.docs
            .firstWhere(
              (doc) => _serializer.deserialize(doc.data()).token == token,
              orElse: () =>
                  throw StateError('No user found with the given token'),
            )
            .data());
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting User: $e');
    }
    return null;
  }

  /// Retrieves a single `User` by its name.
  /// This method retrieves a single `User` object from Firestore by its name.
  /// This method is used to retrieve a `User` object when the ID is not available.
  ///
  /// Parameters:
  /// - `String name`: The name of the `User` to retrieve.
  Future<User?> getByName(String name) async {
    try {
      // Query Firestore for documents where 'name' matches the given name
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where('name', isEqualTo: name)
          .limit(1) // Fetch only the first match
          .get();

      // If no document is found, return null
      if (querySnapshot.docs.isEmpty) return null;

      // Deserialize the first document
      return _serializer.deserialize(querySnapshot.docs.first.data());
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting User by name: $e');
      return null;
    }
  }

  /// Deletes a `User` by its ID.
  /// This method deletes a `User` object from Firestore by its ID.
  ///
  /// Parameters:
  /// - `Uuid id`: The ID of the `User` to delete.
  @override
  Future<void> delete(String token) async {
    try {
      await _firestore.collection(collectionPath).get().then((querySnapshot) {
        // Filter documents to find the one with token == id
        final userDoc = querySnapshot.docs.firstWhere(
          (doc) => _serializer.deserialize(doc.data()).token == token,
          orElse: () => throw StateError('No user found with the given token'),
        );

        userDoc.reference.delete();
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting User: $e');
    }
  }

  /// Adds a new `User` to Firestore.
  /// This method adds a new `User` object to Firestore.
  /// The `User` object is serialized into a Map using the `UserSerializer` class.
  ///
  /// Parameters:
  /// - `User value`: The `User` object to add.
  ///
  @override
  Future<void> post(User value) async {
    try {
      // Check if the username already exists
      final existingUser = await _firestore
          .collection(collectionPath)
          .where('name', isEqualTo: value.name)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        debugPrint('Error: Username "${value.name}" already exists.');
        return; // Exit early to prevent overwriting
      }

      // If the username is unique, proceed to add the user
      await _firestore
          .collection(collectionPath)
          .doc(_getFileName(value.name))
          .set(_serializer.serialize(value));

    } catch (e) {
      if (kDebugMode) debugPrint('Error adding User: $e');
    }
  }

  /// Updates an existing `User` by its ID.
  /// This method updates an existing `User` object in Firestore by its ID.
  /// The `User` object is serialized into a Map using the `UserSerializer` class.
  /// The `SetOptions(merge: true)` option is used to merge the new data with the existing data.
  ///
  /// Parameters:
  /// - `Uuid id`: The ID of the `User` to update.
  /// - `User value`: The new `User` object to update.
  @override
  Future<void> put(String token, User value) async {
    try {
      await _firestore.collection(collectionPath).get().then((querySnapshot) {
        // Filter documents to find the one with token == id
        querySnapshot.docs.firstWhere(
          (doc) => _serializer.deserialize(doc.data()).token == token,
          orElse: () => throw StateError('No user found with the given token'),
        );

        _firestore
            .collection(collectionPath)
            .doc(_getFileName(value.name))
            .set(_serializer.serialize(value), SetOptions(merge: true));
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating User: $e');
    }
  }

  /// Deletes the token of a `User` object.
  /// This method deletes the token of a `User` object in Firestore.
  /// This method is used to log out a user by deleting their token.
  /// The `SetOptions(merge: true)` option is used to merge the new data with the existing data.
  /// The token is set to an empty string to indicate that the user is logged out.
  /// The `Uuid` ID of the `User` is used to identify the user.
  ///
  /// Parameters:
  /// - `Uuid id`: The ID of the `User` to update.
  Future<void> deleteToken(String token) async {
    try {
      await _firestore.collection(collectionPath).get().then((querySnapshot) {
        // Filter documents to find the one with token == token
        QueryDocumentSnapshot doc = querySnapshot.docs.firstWhere(
          (doc) =>
              _serializer.deserialize(doc.data()).token == token.toString(),
          orElse: () => throw StateError('No user found with the given token'),
        );

        _firestore
            .collection(collectionPath)
            .doc(_getFileName(doc['name']))
            .set({'token': null}, SetOptions(merge: true));
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting token: $e');
    }
  }

  /// Updates the token of a `User` object.
  /// This method updates the token of a `User` object in Firestore.
  /// This method is used to log in a user by updating their token.
  /// The `SetOptions(merge: true)` option is used to merge the new data with the existing data.
  /// The token is set to the new token value to indicate that the user is logged in.
  ///
  /// Parameters:
  /// - `String name`: The name of the `User` to update.
  /// - `String token`: The new token value.
  Future<void> putToken(String name, String token) async {
    try {
      await _firestore.collection(collectionPath).get().then((querySnapshot) {
        // Filter documents to find the one with name == name
        querySnapshot.docs.firstWhere(
          (doc) => _serializer.deserialize(doc.data()).name == name,
          orElse: () => throw StateError('No user found with the given name'),
        );

        _firestore
            .collection(collectionPath)
            .doc(_getFileName(name))
            .set({'token': token}, SetOptions(merge: true));
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating token: $e');
    }
  }
}
