import 'dart:async';
import 'dart:convert';
import 'package:air_guard/services/results.dart';
import 'package:air_guard/util/right.dart';
import 'package:air_guard/util/left.dart';
import 'package:http/http.dart' as http;
import 'package:air_guard/domain/enteties/coordinates.dart';
import 'package:air_guard/domain/models/air_quality.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Service class responsible for fetching air quality data.
///
/// This class interacts with the OpenWeatherMap API to fetch air quality data
/// based on the user's current location. It uses the API key stored in the
/// .env file to authenticate requests.

class AirQualityService {
  /// Constructor for the AirQualityService class.
  ///
  /// The constructor initializes the API key by loading it from the .env file.
  /// The API key is used to authenticate requests to the OpenWeatherMap API.
  /// The .env file should contain the API key as a key-value pair.
  String apiKey = '';
  final Completer<void> _apiKeyCompleter = Completer<void>();

  AirQualityService() {
    if (kIsWeb) {
      _loadApiKeyFromConfig();
    }
  }

  /// Asynchronously loads the API key from the config file.
  /// This method is used when running the app in a web browser.
  /// It sends a GET request to the server to fetch the API key from the config file.
  /// The API key is then stored in the [apiKey] property.
  /// If the request fails, an error message is returned.
  /// The [Completer] is used to notify the calling code when the API key has been loaded.
  Future<void> _loadApiKeyFromConfig() async {
    final response = await http.get(Uri.parse('/config.json'));
    if (response.statusCode == 200) {
      final config = jsonDecode(response.body);
      apiKey = config['API_KEY'];
      _apiKeyCompleter.complete();
    } else {
      _apiKeyCompleter.completeError('Failed to load API key');
    }
  }

  /// Asynchronously fetches air quality data based on the provided coordinates.
  ///
  /// This method sends a GET request to the OpenWeatherMap API to fetch air quality data
  /// for the given coordinates. It returns an [AirQualityResult] instance representing
  /// the result of the operation.
  ///
  /// If the request is successful, the method returns a [Right] instance containing the
  /// fetched air quality data. If the request fails due to an invalid API key, invalid
  /// coordinates, or other errors, the method returns a [Left] instance containing an
  /// appropriate error message.
  Future<AirQualityResult> getAirQuality(Coordinates coordinates) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=${coordinates.latitude}&lon=${coordinates.longitude}&appid=$apiKey');

    try {
      final response = await http.get(url);
      switch (response.statusCode) {
        case 200:
          return success(AirQuality.fromJson(jsonDecode(response.body)));
        case 401:
          return failure(const InvalidKey());
        default:
          return failure(const InvalidCoordinates());
      }
    } catch (e) {
      return failure(const ApiError()); // Handle generic errors
    }
  }
}
