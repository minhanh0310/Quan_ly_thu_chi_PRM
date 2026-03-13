import 'package:flutter/material.dart';

Map<String, dynamic> iconDataToMap(IconData icon) {
  return {
    'codePoint': icon.codePoint,
    'fontFamily': icon.fontFamily,
    'fontPackage': icon.fontPackage,
    'matchTextDirection': icon.matchTextDirection,
  };
}

IconData iconDataFromMap(Map<dynamic, dynamic> map) {
  return IconData(
    map['codePoint'] as int,
    fontFamily: map['fontFamily'] as String?,
    fontPackage: map['fontPackage'] as String?,
    matchTextDirection: map['matchTextDirection'] as bool? ?? false,
  );
}

int colorToValue(Color color) => color.value;

Color colorFromValue(int value) => Color(value);

int dateTimeToMillis(DateTime date) => date.millisecondsSinceEpoch;

DateTime dateTimeFromMillis(dynamic value) {
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      return DateTime.fromMillisecondsSinceEpoch(parsed);
    }
    final date = DateTime.tryParse(value);
    if (date != null) return date;
  }
  return DateTime.now();
}
