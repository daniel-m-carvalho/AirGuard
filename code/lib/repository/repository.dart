/// An abstract class that defines a generic repository interface.
///
/// This class provides methods for basic CRUD (Create, Read, Update, Delete)
/// operations on a repository of type `T` with identifiers of type `I`.
///
/// Type Parameters:
/// - `T`: The type of the objects stored in the repository.
/// - `I`: The type of the identifier used to uniquely identify objects in the repository.
abstract class Repository<T, I> {
  /// Retrieves an object from the repository by its identifier.
  ///
  /// Returns a `Future` that completes with the object of type `T` if found,
  /// or `null` if no object with the given identifier exists.
  ///
  /// Parameters:
  /// - `id`: The identifier of the object to retrieve.
  Future<T?> get(I id);

  /// Deletes an object from the repository by its identifier.
  ///
  /// Parameters:
  /// - `id`: The identifier of the object to delete.
  void delete(I id);

  /// Adds a new object to the repository.
  ///
  /// Parameters:
  /// - `value`: The object of type `T` to add to the repository.
  void post(T value);

  /// Updates an existing object in the repository.
  ///
  /// Parameters:
  /// - `id`: The identifier of the object to update.
  /// - `value`: The new value of type `T` for the object.
  void put(I id, T value);

  /// Generates a file name for the repository object based on the repository name and identifier.
  ///
  /// Returns a `String` representing the file name.
  ///
  /// Parameters:
  /// - `repo`: The name of the repository.
  /// - `id`: The identifier of the object.
  String getFileName(String repo, I id) => '$repo-$id';
}
