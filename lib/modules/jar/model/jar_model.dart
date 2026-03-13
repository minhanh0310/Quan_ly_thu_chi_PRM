import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/serialization_helpers.dart';

class JarModel {
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final double targetPercent;
  final double actualPercent;
  final double amount;
  final int activePlansCount;
  final String? id;

  const JarModel({
    this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.targetPercent,
    required this.actualPercent,
    required this.amount,
    this.activePlansCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': colorToValue(color),
      'icon': iconDataToMap(icon),
      'targetPercent': targetPercent,
      'actualPercent': actualPercent,
      'amount': amount,
      'activePlansCount': activePlansCount,
    };
  }

  factory JarModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return JarModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      color: colorFromValue((map['color'] as num?)?.toInt() ?? 0xFF9E9E9E),
      icon: map['icon'] is Map
          ? iconDataFromMap(map['icon'] as Map<dynamic, dynamic>)
          : Icons.account_balance_wallet_rounded,
      targetPercent: (map['targetPercent'] as num?)?.toDouble() ?? 0,
      actualPercent: (map['actualPercent'] as num?)?.toDouble() ?? 0,
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      activePlansCount: (map['activePlansCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class DistributionEntry {
  final String month;
  final String subtitle;
  final double amount;
  final String? id;

  const DistributionEntry({
    this.id,
    required this.month,
    required this.subtitle,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month,
      'subtitle': subtitle,
      'amount': amount,
    };
  }

  factory DistributionEntry.fromMap(String id, Map<dynamic, dynamic> map) {
    return DistributionEntry(
      id: id,
      month: map['month'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
    );
  }
}
