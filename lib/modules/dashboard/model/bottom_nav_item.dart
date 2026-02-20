import 'package:flutter/material.dart';

class BottomNavItem {
  final Widget screen;
  final String route;
  final String label;
  final String iconPath;

  const BottomNavItem({
    required this.screen,
    required this.route,
    required this.label,
    required this.iconPath,
  });
}
