import 'package:flutter/material.dart';
import 'package:weather_app/enterapp.dart';
import './weatherscreen.dart';

void main() => runApp(const WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // Text color
        ),

      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white, // Text color
        ),
      ),
      themeMode: ThemeMode.dark,

    );
  }
}
