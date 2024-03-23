import 'package:flutter/material.dart';
import './MyApi.dart'; //TS fixed this



void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApi",
      debugShowCheckedModeBanner: false,
      home: MyApi(),
    );
  }
}
