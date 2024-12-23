import 'package:air_guard/domain/enteties/components.dart';
import 'package:air_guard/domain/enteties/coordinates.dart';
import 'package:air_guard/view_ models/air_quality_view_model.dart';
import 'package:air_guard/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AirQualityView extends StatelessWidget {
  const AirQualityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        mainItem: TextButton.icon(
          onPressed: () {
            // Navigate back to the home view
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.shield, color: Colors.black),
          label: const Text(
            'AirGuard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        additionalItems: [],
      ),
      body: Container(
        color: const Color.fromARGB(
            255, 122, 135, 230), // Set the background color
        child: FutureBuilder<void>(
          future: Provider.of<AirQualityViewModel>(context, listen: false)
              .fetchAirQuality(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Consumer<AirQualityViewModel>(
                builder: (context, airQualityViewModel, child) {
                  if (airQualityViewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (airQualityViewModel.errorMessage != null) {
                    return Center(
                        child:
                            Text('Error: ${airQualityViewModel.errorMessage}'));
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Air Quality',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildVolocimeter(
                                airQualityViewModel.airQuality?.qualityIndex ??
                                    0),
                            _buildComponentsAndCoordinates(
                              airQualityViewModel.airQuality?.components,
                              airQualityViewModel.airQuality?.coordinates,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Color getQualityColor(int qualityIndex) {
    switch (qualityIndex) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.redAccent;
      case 5:
        return const Color.fromARGB(255, 176, 39, 183);
      default:
        return Colors.grey;
    }
  }

  Widget _buildVolocimeter(int qualityIndex) {
    double minValue = 0;
    double maxValue = 500; // Adjust this based on your AQI scale
    double value = (qualityIndex * 100).toDouble();

    String airQualityMessage = getAirQualityMessage(qualityIndex);

    return Column(
      children: [
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: minValue,
              maximum: maxValue,
              startAngle: 180,
              endAngle: 360,
              showLabels: false,
              showTicks: false,
              axisLineStyle: AxisLineStyle(
                thickness: 0.2,
                thicknessUnit: GaugeSizeUnit.factor,
                color: Colors.grey.withOpacity(0.2),
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: value,
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: getQualityColor(qualityIndex),
                )
              ],
              annotations: <GaugeAnnotation>[
                // Overlay the number and quality message in the center
                GaugeAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        qualityIndex.toString(),
                        style: const TextStyle(
                          fontSize: 36, // Larger font size for the number
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        airQualityMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  positionFactor: 0.0, // Aligns content to the center
                  angle: 90,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComponentsAndCoordinates(
      Components? components, Coordinates? coordinates) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Components Section
        Expanded(
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Components:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildComponentRow('CO', components?.co ?? 0),
                  _buildComponentRow('NO', components?.no ?? 0),
                  _buildComponentRow('NO2', components?.no2 ?? 0),
                  _buildComponentRow('O3', components?.o3 ?? 0),
                  _buildComponentRow('SO2', components?.so2 ?? 0),
                  _buildComponentRow('PM2.5', components?.pm2_5 ?? 0),
                  _buildComponentRow('PM10', components?.pm10 ?? 0),
                  _buildComponentRow('NH3', components?.nh3 ?? 0),
                ],
              ),
            ),
          ),
        ),
        // Coordinates Section
        Expanded(
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coordinates:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    'Latitude: ${coordinates?.latitude.toString() ?? 'N/A'}',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    'Longitude: ${coordinates?.longitude.toString() ?? 'N/A'}',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getAirQualityMessage(int qualityIndex) {
    switch (qualityIndex) {
      case 1:
        return "Good";
      case 2:
        return "Fair";
      case 3:
        return "Moderate";
      case 4:
        return "Poor";
      case 5:
        return "Very Poor";
      default:
        return "Unknown";
    }
  }

  Widget _buildComponentRow(String name, double value) {
    return Text(
      '$name: ${value.toString()}',
      style: const TextStyle(color: Colors.black, fontSize: 20),
    );
  }
}
