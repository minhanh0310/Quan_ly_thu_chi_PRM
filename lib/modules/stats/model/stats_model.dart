import 'package:flutter/material.dart';

/// Model for category expense data in statistics
class CategoryExpense {
  final String category;
  final double amount;
  final Color color;
  final IconData icon;

  const CategoryExpense({
    required this.category,
    required this.amount,
    required this.color,
    required this.icon,
  });
}

/// Model for monthly budget vs actual comparison
class MonthlyBudgetData {
  final String month;
  final double budget;
  final double actual;

  const MonthlyBudgetData({
    required this.month,
    required this.budget,
    required this.actual,
  });

  /// Calculate percentage of budget used
  double get percentageUsed => budget > 0 ? (actual / budget) * 100 : 0;

  /// Check if overspent
  bool get isOverspent => actual > budget;

  /// Calculate remaining or overspent amount
  double get remainingAmount => budget - actual;

  /// Get status based on percentage
  BudgetStatus get status {
    final percentage = percentageUsed;
    if (percentage >= 100) return BudgetStatus.overSpent;
    if (percentage >= 80) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }
}

/// Budget status enum
enum BudgetStatus {
  safe,    // < 80%
  warning, // 80% - 100%
  overSpent, // > 100%
}

/// Model for overall statistics
class StatsData {
  final double totalBudget;
  final double totalExpense;
  final double totalIncome;
  final List<MonthlyBudgetData> monthlyData;
  final List<CategoryExpense> categoryExpenses;
  final String currentMonth;

  const StatsData({
    required this.totalBudget,
    required this.totalExpense,
    required this.totalIncome,
    required this.monthlyData,
    required this.categoryExpenses,
    required this.currentMonth,
  });

  /// Calculate remaining amount
  double get remainingAmount => totalBudget - totalExpense;

  /// Check if overspent
  bool get isOverSpent => totalExpense > totalBudget;

  /// Calculate percentage used
  double get percentageUsed => totalBudget > 0 ? (totalExpense / totalBudget) * 100 : 0;

  /// Get budget status
  BudgetStatus get status {
    final percentage = percentageUsed;
    if (percentage >= 100) return BudgetStatus.overSpent;
    if (percentage >= 80) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }
}
