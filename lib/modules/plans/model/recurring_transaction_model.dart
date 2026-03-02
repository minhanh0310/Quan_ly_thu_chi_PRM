import 'package:flutter/material.dart';

enum RecurringCycle { daily, weekly, monthly, yearly }

class RecurringTransactionModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isIncome;
  final RecurringCycle cycle;
  final DateTime nextDueDate;
  final DateTime startDate;
  final String? notes;
  final bool isActive;

  const RecurringTransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
    required this.isIncome,
    required this.cycle,
    required this.nextDueDate,
    required this.startDate,
    this.notes,
    this.isActive = true,
  });

  String get cycleLabel {
    switch (cycle) {
      case RecurringCycle.daily:
        return 'Daily';
      case RecurringCycle.weekly:
        return 'Weekly';
      case RecurringCycle.monthly:
        return 'Monthly';
      case RecurringCycle.yearly:
        return 'Yearly';
    }
  }

  int get daysUntilDue => nextDueDate.difference(DateTime.now()).inDays;

  bool get isDueSoon => daysUntilDue <= 3 && daysUntilDue >= 0;

  bool get isOverdue => DateTime.now().isAfter(nextDueDate);

  static List<RecurringTransactionModel> get mockList => [
    RecurringTransactionModel(
      id: '1',
      title: 'Electricity Bill',
      amount: 350000,
      category: 'Utilities',
      categoryIcon: Icons.bolt_rounded,
      categoryColor: const Color(0xFFFFC94D),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 5),
      startDate: DateTime(2025, 1, 1),
      notes: 'EVN District 7',
    ),
    RecurringTransactionModel(
      id: '2',
      title: 'Water Bill',
      amount: 150000,
      category: 'Utilities',
      categoryIcon: Icons.water_drop_rounded,
      categoryColor: const Color(0xFF00D09E),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 10),
      startDate: DateTime(2025, 1, 1),
    ),
    RecurringTransactionModel(
      id: '3',
      title: 'Internet',
      amount: 250000,
      category: 'Utilities',
      categoryIcon: Icons.wifi_rounded,
      categoryColor: const Color(0xFF5B4EFF),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 15),
      startDate: DateTime(2025, 1, 15),
    ),
    RecurringTransactionModel(
      id: '4',
      title: 'Apartment Rent',
      amount: 8000000,
      category: 'Housing',
      categoryIcon: Icons.home_rounded,
      categoryColor: const Color(0xFF6C5CE7),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 1),
      startDate: DateTime(2025, 1, 1),
    ),
    RecurringTransactionModel(
      id: '5',
      title: 'Phone Plan',
      amount: 200000,
      category: 'Utilities',
      categoryIcon: Icons.phone_android_rounded,
      categoryColor: const Color(0xFFFF6B93),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 20),
      startDate: DateTime(2025, 2, 1),
    ),
    RecurringTransactionModel(
      id: '6',
      title: 'Netflix',
      amount: 200000,
      category: 'Entertainment',
      categoryIcon: Icons.movie_rounded,
      categoryColor: const Color(0xFFE50914),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 12),
      startDate: DateTime(2025, 3, 1),
    ),
    RecurringTransactionModel(
      id: '7',
      title: 'Salary',
      amount: 25000000,
      category: 'Income',
      categoryIcon: Icons.attach_money_rounded,
      categoryColor: const Color(0xFF00D09E),
      isIncome: true,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 31),
      startDate: DateTime(2025, 1, 1),
    ),
    RecurringTransactionModel(
      id: '8',
      title: 'Spotify',
      amount: 59000,
      category: 'Entertainment',
      categoryIcon: Icons.music_note_rounded,
      categoryColor: const Color(0xFF1DB954),
      isIncome: false,
      cycle: RecurringCycle.monthly,
      nextDueDate: DateTime(2026, 3, 8),
      startDate: DateTime(2025, 4, 1),
    ),
  ];
}
