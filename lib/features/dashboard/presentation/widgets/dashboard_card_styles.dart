import 'package:flutter/material.dart';

class DashboardCardStyles {
  static const EdgeInsets cardMargin = EdgeInsets.all(12);

  static const EdgeInsets cardPadding = EdgeInsets.all(16);

  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(16),
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration insightBox(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
