import 'package:flutter/material.dart';

class Formatters {
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
      return points > 0 ? Colors.green[700] : Colors.red[700];
    } else {
      return null;
    }
  }
}
