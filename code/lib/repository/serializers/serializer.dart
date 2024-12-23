/// An abstract class that defines the interface for serializing and
/// deserializing objects of type `T`.
abstract class Serializer<T> {
  /// Serializes an object of type `T` into a `Map<String, dynamic>`.
  ///
  /// [object] - The object to be serialized.
  ///
  /// Returns a `Map<String, dynamic>` representation of the object.
  Map<String, dynamic> serialize(T object);

  /// Deserializes a `Map<String, dynamic>` into an object of type `T`.
  ///
  /// [map] - The map to be deserialized.
  ///
  /// Returns an object of type `T` created from the map.
  T deserialize(Map<String, dynamic> map);
}
