import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '500 Scorer',
      home: HomeScreen(),
      theme: new ThemeData(
        primaryColor: Colors.blueGrey,
      ),
    );
  }
}
