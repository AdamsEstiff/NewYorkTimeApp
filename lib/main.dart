import 'package:flutter/material.dart';
import 'package:new_york_times_app/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewYork Times',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "times new roman",
      ),
      home: Home(),
    );
  }
}
