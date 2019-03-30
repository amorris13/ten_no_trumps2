import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

import 'home_screen.dart';
import 'login_screen.dart';
import 'match_screen.dart';
import 'new_hand_screen.dart';
import 'new_match_screen.dart';
import 'round_screen.dart';
import 'settings_screen.dart';

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
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => screenFromRoute(context, settings),
        );
      },
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

  Widget screenFromRoute(BuildContext context, RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return HomeScreen();
      case SettingsScreen.routeName:
        return SettingsScreen();
      case LoginScreen.routeName:
        return LoginScreen();
      case MatchScreen.routeName:
        return MatchScreen.fromArgs(settings.arguments);
      case RoundScreen.routeName:
        return RoundScreen.fromArgs(settings.arguments);
      case NewMatchScreen.routeName:
        return NewMatchScreen.fromArgs(settings.arguments);
      case NewHandScreen.routeName:
        return NewHandScreen.fromArgs(settings.arguments);
      default:
        return null;
    }
  }
}
