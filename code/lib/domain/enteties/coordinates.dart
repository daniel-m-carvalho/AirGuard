/// Represents geographical coordinates with latitude and longitude.
///
/// This class is used to store and manipulate geographical coordinates.
/// It contains two properties: `latitude` and `longitude`, both of which
/// are required to create an instance of `Coordinates`.
///
/// Properties:
/// - `latitude` (double): The latitude of the coordinates.
/// - `longitude` (double): The longitude of the coordinates.
library;

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({
    required this.longitude,
    required this.latitude,
  });
}
