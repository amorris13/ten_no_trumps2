import 'package:flutter/material.dart';
import 'matches_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '500 Scorer',
      home: MyHomePage(),
      theme: new ThemeData(
        primaryColor: Colors.blueGrey,
      ),
    );
  }
}
