import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/serialization_helpers.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'categoryIcon': iconDataToMap(categoryIcon),
      'categoryColor': colorToValue(categoryColor),
      'isIncome': isIncome,
      'cycle': cycle.name,
      'nextDueDate': dateTimeToMillis(nextDueDate),
      'startDate': dateTimeToMillis(startDate),
      'notes': notes,
      'isActive': isActive,
    };
  }

  factory RecurringTransactionModel.fromMap(
    String id,
    Map<dynamic, dynamic> map,
  ) {
    return RecurringTransactionModel(
      id: id,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      category: map['category'] as String? ?? '',
      categoryIcon: map['categoryIcon'] is Map
          ? iconDataFromMap(map['categoryIcon'] as Map<dynamic, dynamic>)
          : Icons.repeat_rounded,
      categoryColor: colorFromValue(
        (map['categoryColor'] as num?)?.toInt() ?? 0xFF9E9E9E,
      ),
      isIncome: map['isIncome'] as bool? ?? false,
      cycle: RecurringCycle.values.firstWhere(
        (e) => e.name == (map['cycle'] as String? ?? 'monthly'),
        orElse: () => RecurringCycle.monthly,
      ),
      nextDueDate: dateTimeFromMillis(map['nextDueDate']),
      startDate: dateTimeFromMillis(map['startDate']),
      notes: map['notes'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
