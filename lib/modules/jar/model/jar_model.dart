import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class JarModel {
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final double targetPercent;
  final double actualPercent;
  final double amount;
  final int activePlansCount;

  const JarModel({
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.targetPercent,
    required this.actualPercent,
    required this.amount,
    this.activePlansCount = 0,
  });

  /// Mock data — replace with real data source later
  static const List<JarModel> mockList = [
    JarModel(
      name: 'Necessities',
      description: 'Living expenses, food, utility bills',
      color: Color(0xFF4CAF50),
      icon: Icons.home_rounded,
      targetPercent: 0.55,
      actualPercent: 0.047,
      amount: 2500,
    ),
    JarModel(
      name: 'Financial Freedom',
      description: 'Invest, accumulate for big plans',
      color: Color(0xFF5B4EFF),
      icon: Icons.trending_up_rounded,
      targetPercent: 0.10,
      actualPercent: 0.841,
      amount: 45000,
      activePlansCount: 2,
    ),
    JarModel(
      name: 'Education',
      description: 'Learning, personal development',
      color: Color(0xFFFFC94D),
      icon: Icons.school_rounded,
      targetPercent: 0.10,
      actualPercent: 0.028,
      amount: 1500,
    ),
    JarModel(
      name: 'Long-term Savings',
      description: 'Emergency fund, big purchases',
      color: Color(0xFF26C6DA),
      icon: Icons.account_balance_rounded,
      targetPercent: 0.10,
      actualPercent: 0.028,
      amount: 1500,
      activePlansCount: 2,
    ),
    JarModel(
      name: 'Entertainment',
      description: 'Values, travel, rewards',
      color: Color(0xFFFF6B93),
      icon: Icons.celebration_rounded,
      targetPercent: 0.10,
      actualPercent: 0.028,
      amount: 1500,
    ),
    JarModel(
      name: 'Give',
      description: 'Charity, gifts, helping others',
      color: Color(0xFFAB47BC),
      icon: Icons.volunteer_activism_rounded,
      targetPercent: 0.05,
      actualPercent: 0.028,
      amount: 1500,
    ),
  ];
}

class DistributionEntry {
  final String month;
  final String subtitle;
  final double amount;

  const DistributionEntry({
    required this.month,
    required this.subtitle,
    required this.amount,
  });

  static List<DistributionEntry> mockList = [
    DistributionEntry(
      month: 'February 2026',
      subtitle: 'jars_screen.auto_distributed'.tr(),
      amount: 5000,
    ),
    DistributionEntry(
      month: 'January 2026',
      subtitle: 'jars_screen.auto_distributed'.tr(),
      amount: 5000,
    ),
  ];
}
