import 'package:air_guard/domain/enteties/coordinates.dart';
import 'package:air_guard/services/results.dart';
import 'package:air_guard/util/left.dart';
import 'package:air_guard/util/right.dart';
import 'package:geolocator/geolocator.dart';

/// Service class responsible for retrieving the user's current location coordinates.
///
/// This class uses the `geolocator` package to interact with the device's location services
/// and obtain the current geographical position of the user. It handles permission checks
/// and requests as necessary.
///
/// Methods:
/// - `Future<LocationResult> getCoordinates()`: Asynchronously retrieves the user's current coordinates.
///   - Checks for location permissions and requests them if not already granted.
///   - If permissions are denied, returns a failure result with `LocationPermissionDenied`.
///   - If permissions are granted, retrieves the current position with high accuracy.
///   - Returns a success result with the user's coordinates or a failure result with `LocationUnavailable` if an error occurs.

class LocationService {
  /// Asynchronously retrieves the user's current coordinates.
  ///
  /// Checks for location permissions and requests them if not already granted.
  /// If permissions are denied, returns a failure result with `LocationPermissionDenied`.
  /// If permissions are granted, retrieves the current position with high accuracy.
  /// Returns a success result with the user's coordinates or a failure result with `LocationUnavailable` if an error occurs.
  Future<LocationResult> getCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return failure(const LocationUnavailable());
    }
    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return failure(const LocationPermissionDenied());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return failure(const LocationPermissionDenied());
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return success(Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    ));
  }
}
