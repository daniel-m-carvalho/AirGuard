import 'package:air_guard/firebase_options.dart';
import 'package:air_guard/services/air_quality_service.dart';
import 'package:air_guard/services/location_service.dart';
import 'package:air_guard/view_%20models/air_quality_view_model.dart';
import 'package:air_guard/view_%20models/auth_view_model.dart';
import 'package:air_guard/views/home/home_view.dart';
import 'package:air_guard/web_url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Ensures Firebase is initialized
  configureApp(); // Configures the app for web
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
            create: (_) =>
                AirQualityViewModel(AirQualityService(), LocationService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirGuard: Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
