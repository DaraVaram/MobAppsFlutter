import 'package:chapter_5/deep_tree.dart';
import 'package:chapter_5/e_commerce_screen_before.dart';
import 'package:chapter_5/flex_screen.dart';
import 'package:chapter_5/labeled_container.dart';
import 'package:flutter/material.dart';
import './labeled_container.dart';
import './profile_screen.dart';
import './e_commerce_screen_after.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        appBarTheme: AppBarTheme(
          elevation: 10,
          titleTextStyle: const TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'LeckerliOne-Regular.ttf',
              fontSize: 24,
            ),
          ).titleLarge,
        ),
      ),
      home: const ECommerceScreenAfter(),
    );
  }
}