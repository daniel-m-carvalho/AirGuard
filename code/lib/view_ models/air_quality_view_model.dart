import 'package:air_guard/domain/enteties/coordinates.dart';
import 'package:air_guard/domain/models/air_quality.dart';
import 'package:air_guard/services/air_quality_service.dart';
import 'package:air_guard/services/location_service.dart';
import 'package:air_guard/services/results.dart';
import 'package:flutter/material.dart';

/// ViewModel class responsible for managing the state of air quality data.
///
/// This class interacts with the [AirQualityService] to fetch air quality data
/// and the [LocationService] to get the user's current coordinates. It extends
/// [ChangeNotifier] to notify listeners about state changes.
///
/// Properties:
/// - `isLoading`: A boolean indicating whether data is currently being loaded.
/// - `errorMessage`: A string that holds any error message encountered during data fetching.
/// - `airQuality`: An instance of [AirQuality] that holds the fetched air quality data.
/// - `coordinates`: An instance of [Coordinates] that holds the user's current location.
///
/// Methods:
/// - `fetchAirQuality()`: Asynchronously fetches the air quality data based on the user's current location.
/// - `_handleError(String error)`: Handles errors by setting the error message and updating the loading state.
/// - `notifyListeners()`: Notifies listeners about state changes.

class AirQualityViewModel extends ChangeNotifier {
  final AirQualityService _service;
  final LocationService _locationService;

  bool isLoading = true;
  String? errorMessage;
  AirQuality? airQuality;
  Coordinates? coordinates;

  AirQualityViewModel(this._service, this._locationService);

  /// Asynchronously fetches the air quality data based on the user's current location.
  ///
  /// This method first retrieves the user's current coordinates using the [LocationService].
  /// If successful, it then fetches the air quality data for those coordinates using the [AirQualityService].
  /// During the data fetching process, the `isLoading` property is set to true and listeners are notified.
  /// If an error occurs at any point, the `_handleError` method is called to handle the error and update the state.
  Future<void> fetchAirQuality() async {
    try {
      // Get coordinates
      LocationResult result = await _locationService.getCoordinates();
      result.fold(
        (error) => _handleError(error.toString()),
        (data) => coordinates = data,
      );

      // Get air quality
      AirQualityResult airQualityResult =
          await _service.getAirQuality(coordinates!);
      airQualityResult.fold(
        (error) => _handleError(error.toString()),
        (data) {
          airQuality = data;
          isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _handleError(e.toString());
    }
  }

  /// Handles errors by setting the error message and updating the loading state.
  ///
  /// This method is called whenever an error occurs during the data fetching process.
  /// It sets the `errorMessage` property to the provided error message, sets `isLoading` to false,
  /// and notifies listeners about the state change.
  void _handleError(String error) {
    errorMessage = error;
    isLoading = false;
    notifyListeners();
  }
}
