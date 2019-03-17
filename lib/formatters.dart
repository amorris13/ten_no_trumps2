import 'package:flutter/material.dart';

class Formatters {
  static final Color winningColor = Colors.green[700];
  static final Color losingColor = Colors.red[700];

  static String formatPoints(int points) {
    if (points > 0) {
      return "+$points";
    } else if (points < 0) {
      return points.toString();
    } else {
      return points.toString();
    }
  }

  static Color getColor(int points, bool biddingTeam) {
    if (biddingTeam) {
      return points > 0 ? winningColor : Colors.red[700];
    } else {
      return null;
    }
  }
}
