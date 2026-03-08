import 'package:flutter/material.dart';

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

  static List<BudgetModel> get mockList => [
    BudgetModel(
      id: '1',
      categoryName: 'Food & Dining',
      categoryIcon: Icons.restaurant_rounded,
      categoryColor: const Color(0xFFFF6B93),
      limitAmount: 5000000,
      spentAmount: 3500000,
      cycle: BudgetCycle.monthly,
      expenseType: ExpenseType.variable,
    ),
    BudgetModel(
      id: '2',
      categoryName: 'Transportation',
      categoryIcon: Icons.directions_car_rounded,
      categoryColor: const Color(0xFF00D09E),
      limitAmount: 2000000,
      spentAmount: 1800000,
      cycle: BudgetCycle.monthly,
      expenseType: ExpenseType.variable,
    ),
    BudgetModel(
      id: '3',
      categoryName: 'Shopping',
      categoryIcon: Icons.shopping_bag_rounded,
      categoryColor: const Color(0xFF5B4EFF),
      limitAmount: 3000000,
      spentAmount: 3200000,
      cycle: BudgetCycle.monthly,
      expenseType: ExpenseType.variable,
    ),
    BudgetModel(
      id: '4',
      categoryName: 'Rent',
      categoryIcon: Icons.home_rounded,
      categoryColor: const Color(0xFF6C5CE7),
      limitAmount: 8000000,
      spentAmount: 8000000,
      cycle: BudgetCycle.monthly,
      expenseType: ExpenseType.fixed,
    ),
    BudgetModel(
      id: '5',
      categoryName: 'Utilities',
      categoryIcon: Icons.bolt_rounded,
      categoryColor: const Color(0xFFFFC94D),
      limitAmount: 1500000,
      spentAmount: 1200000,
      cycle: BudgetCycle.monthly,
      expenseType: ExpenseType.fixed,
    ),
    BudgetModel(
      id: '6',
      categoryName: 'Entertainment',
      categoryIcon: Icons.movie_rounded,
      categoryColor: const Color(0xFF4ECDC4),
      limitAmount: 1000000,
      spentAmount: 400000,
      cycle: BudgetCycle.monthly,
      expenseType: ExpenseType.variable,
    ),
  ];
}
