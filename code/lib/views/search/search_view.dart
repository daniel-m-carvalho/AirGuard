import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:air_guard/views/air_quality/air_quality_view.dart';
import 'package:air_guard/views/widgets/nav_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  final String title = 'Search';
  final String searchMessage = 'Search air quality in your area >';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        mainItem: TextButton.icon(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the home view
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
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 122, 135, 230),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Using the correct asset path
                Image.asset('assets/search.gif'),
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to AirQualityView
                    String? errorMessage =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AirQualityView(),
                    ));

                    if (errorMessage != null) {
                      // Display error message using toast notification
                      Fluttertoast.showToast(
                        msg: errorMessage,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: const Color.fromARGB(255, 211, 17, 17),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 182, 36),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: Text(searchMessage,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
