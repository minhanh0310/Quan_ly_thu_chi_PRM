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
  final List<MonthlyBudgetData> monthlyData;
  final List<CategoryExpense> categoryExpenses;
  final String currentMonth;

  const StatsData({
    required this.totalBudget,
    required this.totalExpense,
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

  /// Mock data for demonstration
  static StatsData get mockData => StatsData(
    totalBudget: 5000.0,
    totalExpense: 4250.0,
    currentMonth: 'February 2026',
    monthlyData: [
      MonthlyBudgetData(month: 'Jan', budget: 4500, actual: 3800),
      MonthlyBudgetData(month: 'Feb', budget: 5000, actual: 4250),
    ],
    categoryExpenses: [
      CategoryExpense(
        category: 'Necessities',
        amount: 1800,
        color: const Color(0xFF4CAF50),
        icon: Icons.home_rounded,
      ),
      CategoryExpense(
        category: 'Food',
        amount: 850,
        color: const Color(0xFFFF9800),
        icon: Icons.restaurant_rounded,
      ),
      CategoryExpense(
        category: 'Transportation',
        amount: 450,
        color: const Color(0xFF2196F3),
        icon: Icons.directions_car_rounded,
      ),
      CategoryExpense(
        category: 'Entertainment',
        amount: 600,
        color: const Color(0xFFE91E63),
        icon: Icons.movie_rounded,
      ),
      CategoryExpense(
        category: 'Shopping',
        amount: 350,
        color: const Color(0xFF9C27B0),
        icon: Icons.shopping_bag_rounded,
      ),
      CategoryExpense(
        category: 'Others',
        amount: 200,
        color: const Color(0xFF607D8B),
        icon: Icons.more_horiz_rounded,
      ),
    ],
  );
}
