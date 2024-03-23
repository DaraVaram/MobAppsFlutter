
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './future_page.dart';
import './geolocation.dart';
import './navigation_dialog.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: const FuturePage(),
      //home: const LocationScreen(),
      home: const NavigationDialogScreen(),
    );
  }
}

