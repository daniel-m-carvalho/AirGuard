import 'package:air_guard/repository/repository.dart';
import 'package:air_guard/repository/serializers/health_measure_serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:air_guard/domain/models/health_measure.dart';
import 'package:flutter/foundation.dart';

/// A repository class for managing `HealthMeasure` objects in Firestore.
///
/// This class provides methods to perform CRUD operations on `HealthMeasure`
/// objects stored in a Firestore collection. The collection path is defined
/// by the `collectionPath` variable.
///
/// Methods:
/// - `Future<HealthMeasure?> get(int id)`: Retrieves a single `HealthMeasure`
///   by its ID.
/// - `Future<void> delete(int id)`: Deletes a `HealthMeasure` by its ID.
/// - `Future<void> post(HealthMeasure value)`: Adds a new `HealthMeasure`.
/// - `Future<void> put(int id, HealthMeasure value)`: Updates an existing
///   `HealthMeasure` or creates it if it doesn't exist.
/// - `Future<List<HealthMeasure>> getAll(int qualityIndex)`: Retrieves all
///   `HealthMeasure` objects with a specific `qualityIndex`.
///
/// Private Methods:
/// - `String _getFileName(int id)`: Generates the file name for a `HealthMeasure` by its ID.
class MeasureRepository extends Repository<HealthMeasure, int> {
  String _getFileName(int id) => getFileName('health_measure', id);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HealthMeasureSerializer _serializer = HealthMeasureSerializer();
  final String collectionPath = 'health_measures';

  /// Retrieves a single `HealthMeasure` by its ID.
  /// This method retrieves a single `HealthMeasure` object from Firestore by its ID.
  ///
  /// Parameters:
  /// - `int id`: The ID of the `HealthMeasure` to retrieve.
  ///
  /// Returns:
  /// - A `Future` that resolves to the `HealthMeasure` object with the given ID.
  /// - If no `HealthMeasure` is found with the given ID, the `Future` resolves to `null`.
  @override
  Future<HealthMeasure?> get(int id) async {
    try {
      final doc = await _firestore
          .collection(collectionPath)
          .doc(_getFileName(id))
          .get();
      if (doc.exists) {
        return _serializer.deserialize(doc.data()!);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting HealthMeasure: $e');
    }
    return null;
  }

  /// Deletes a `HealthMeasure` by its ID.
  /// This method deletes a `HealthMeasure` object from Firestore by its ID.
  /// If no `HealthMeasure` is found with the given ID, the method does nothing.
  ///
  /// Parameters:
  /// - `int id`: The ID of the `HealthMeasure` to delete.
  @override
  Future<void> delete(int id) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(_getFileName(id))
          .delete();
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting HealthMeasure: $e');
    }
  }

  /// Adds a new `HealthMeasure` to the repository.
  /// This method adds a new `HealthMeasure` object to the Firestore collection.
  /// If a `HealthMeasure` with the same ID already exists, the method overwrites it.
  ///
  /// Parameters:
  /// - `HealthMeasure value`: The `HealthMeasure` object to add.
  @override
  Future<void> post(HealthMeasure value) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(_getFileName(value.id))
          .set(_serializer.serialize(value));
    } catch (e) {
      if (kDebugMode) debugPrint('Error adding HealthMeasure: $e');
    }
  }

  /// Updates an existing `HealthMeasure` or creates it if it doesn't exist.
  /// This method updates an existing `HealthMeasure` object in Firestore.
  /// If no `HealthMeasure` with the given ID exists, the method creates a new one.
  ///
  /// Parameters:
  /// - `int id`: The ID of the `HealthMeasure` to update.
  /// - `HealthMeasure value`: The new `HealthMeasure` object to store.
  @override
  Future<void> put(int id, HealthMeasure value) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(_getFileName(id))
          .set(_serializer.serialize(value), SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating HealthMeasure: $e');
    }
  }

  // Get all HealthMeasures with a specific qualityIndex
  Future<List<HealthMeasure>> getAll(int qualityIndex) async {
    try {
      return await _firestore
          .collection(collectionPath)
          .where('qualityIndex', isEqualTo: qualityIndex)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((doc) => _serializer.deserialize(doc.data()))
              .toList());
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting HealthMeasures: $e');
      return [];
    }
  }
}
