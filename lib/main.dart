import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

import 'home_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
      title: '500 Scorer',
      home: HomeScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
        typography: Typography(
          platform: defaultTargetPlatform,
          englishLike: Typography.englishLike2018,
          dense: Typography.dense2018,
          tall: Typography.tall2018,
        ),
      ),
    );
  }
}
