import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/serialization_helpers.dart';

enum BudgetCycle { weekly, monthly, yearly }

enum ExpenseType { fixed, variable }

class BudgetModel {
  final String id;
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final double limitAmount;
  final double spentAmount;
  final BudgetCycle cycle;
  final ExpenseType expenseType;
  final DateTime? startDate;

  const BudgetModel({
    required this.id,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.limitAmount,
    required this.spentAmount,
    required this.cycle,
    required this.expenseType,
    this.startDate,
  });

  double get remainingAmount => limitAmount - spentAmount;
  
  double get percentUsed => limitAmount > 0 ? (spentAmount / limitAmount).clamp(0.0, 1.5) : 0;
  
  bool get isOverspent => spentAmount > limitAmount;
  
  bool get isWarning => percentUsed >= 0.8 && percentUsed < 1.0;
  
  bool get isSafe => percentUsed < 0.8;

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryIcon': iconDataToMap(categoryIcon),
      'categoryColor': colorToValue(categoryColor),
      'limitAmount': limitAmount,
      'spentAmount': spentAmount,
      'cycle': cycle.name,
      'expenseType': expenseType.name,
      'startDate': startDate != null ? dateTimeToMillis(startDate!) : null,
    };
  }

  factory BudgetModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return BudgetModel(
      id: id,
      categoryName: map['categoryName'] as String? ?? '',
      categoryIcon: map['categoryIcon'] is Map
          ? iconDataFromMap(map['categoryIcon'] as Map<dynamic, dynamic>)
          : Icons.category_rounded,
      categoryColor: colorFromValue(
        (map['categoryColor'] as num?)?.toInt() ?? 0xFF9E9E9E,
      ),
      limitAmount: (map['limitAmount'] as num?)?.toDouble() ?? 0,
      spentAmount: (map['spentAmount'] as num?)?.toDouble() ?? 0,
      cycle: BudgetCycle.values.firstWhere(
        (e) => e.name == (map['cycle'] as String? ?? 'monthly'),
        orElse: () => BudgetCycle.monthly,
      ),
      expenseType: ExpenseType.values.firstWhere(
        (e) => e.name == (map['expenseType'] as String? ?? 'variable'),
        orElse: () => ExpenseType.variable,
      ),
      startDate: map['startDate'] != null
          ? dateTimeFromMillis(map['startDate'])
          : null,
    );
  }
}
