import 'package:air_guard/domain/enteties/components.dart';
import 'package:air_guard/domain/enteties/coordinates.dart';

/// Represents a custom button widget with an icon and text.
///
/// This widget is used to create a button that contains both an icon and text.
/// It provides customization options for the icon, text, and button appearance.
///
/// Properties:
/// - `icon` (IconData): The icon to display inside the button.
/// - `text` (String): The text to display inside the button.
/// - `onPressed` (VoidCallback): The callback function to execute when the button is pressed.
/// - `color` (Color, optional): The background color of the button.
/// - `textColor` (Color, optional): The color of the text inside the button.
class AirQuality {
  final DateTime date;
  final int qualityIndex;
  final Components components;
  final Coordinates coordinates;

  AirQuality({
    required this.date,
    required this.qualityIndex,
    required this.components,
    required this.coordinates,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      date: DateTime.fromMillisecondsSinceEpoch(json['list'][0]['dt'] * 1000),
      qualityIndex: json['list'][0]['main']['aqi'],
      components: Components.fromJson(json['list'][0]['components']),
      coordinates: Coordinates(
        latitude: json['coord']['lat'],
        longitude: json['coord']['lon'],
      ),
    );
  }
}
