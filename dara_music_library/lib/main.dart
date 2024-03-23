import 'package:flutter/material.dart';
import './login_page.dart';
import './musiclibrary.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Darooj's Music Library",
      debugShowCheckedModeBanner: false,
      // home: const LoginPage(),
      home: const Library(username: 'Dara'),
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