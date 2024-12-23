/// A class representing various air quality components.
///
/// This class holds the concentration values of different air pollutants.
///
/// Properties:
/// - `co` (double): Carbon monoxide concentration.
/// - `no` (double): Nitric oxide concentration.
/// - `no2` (double): Nitrogen dioxide concentration.
/// - `o3` (double): Ozone concentration.
/// - `so2` (double): Sulfur dioxide concentration.
/// - `pm2_5` (double): Particulate matter (2.5 micrometers or smaller) concentration.
/// - `pm10` (double): Particulate matter (10 micrometers or smaller) concentration.
/// - `nh3` (double): Ammonia concentration.
///
/// The class also provides a factory constructor to create an instance from a JSON object.
class Components {
  final double co;
  final double no;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;

  Components({
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  /// Creates an instance of [Components] from a JSON object.
  ///
  /// The JSON object is expected to have the following keys:
  /// - `co`: Carbon monoxide concentration.
  /// - `no`: Nitric oxide concentration.
  /// - `no2`: Nitrogen dioxide concentration.
  /// - `o3`: Ozone concentration.
  /// - `so2`: Sulfur dioxide concentration.
  /// - `pm2_5`: Particulate matter (2.5 micrometers or smaller) concentration.
  /// - `pm10`: Particulate matter (10 micrometers or smaller) concentration.
  /// - `nh3`: Ammonia concentration.
  factory Components.fromJson(Map<String, dynamic> json) {
    return Components(
      co: json['co'].toDouble(),
      no: json['no'].toDouble(),
      no2: json['no2'].toDouble(),
      o3: json['o3'].toDouble(),
      so2: json['so2'].toDouble(),
      pm2_5: json['pm2_5'].toDouble(),
      pm10: json['pm10'].toDouble(),
      nh3: json['nh3'].toDouble(),
    );
  }
}
