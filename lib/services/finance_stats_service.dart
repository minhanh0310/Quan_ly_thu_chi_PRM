import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/models/transaction_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/budget_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/model/stats_model.dart';

class FinanceStatsService {
  StatsData buildStats({
    required List<TransactionModel> transactions,
    required List<BudgetModel> budgets,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final currentMonthKey = _monthKey(current);

    final currentMonthTx = transactions.where((t) {
      return _monthKey(t.date) == currentMonthKey;
    }).toList();

    final totalIncome = currentMonthTx
        .where((t) => t.isIncome)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final totalExpense = currentMonthTx
        .where((t) => !t.isIncome)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final totalBudget = budgets.fold<double>(
      0,
      (sum, b) => sum + _budgetForMonth(b, current),
    );

    final monthlyData = _buildMonthlyData(transactions, budgets, current);
    final categoryExpenses =
        _buildCategoryExpenses(currentMonthTx.where((t) => !t.isIncome));

    return StatsData(
      totalBudget: totalBudget,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      monthlyData: monthlyData,
      categoryExpenses: categoryExpenses,
      currentMonth: _monthLabel(current),
    );
  }

  List<MonthlyBudgetData> _buildMonthlyData(
    List<TransactionModel> transactions,
    List<BudgetModel> budgets,
    DateTime now,
  ) {
    final result = <MonthlyBudgetData>[];
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthKey = _monthKey(date);
      final monthTx = transactions.where((t) => _monthKey(t.date) == monthKey);
      final actual = monthTx
          .where((t) => !t.isIncome)
          .fold<double>(0, (sum, t) => sum + t.amount);
      final budget = budgets.fold<double>(
        0,
        (sum, b) => sum + _budgetForMonth(b, date),
      );
      result.add(
        MonthlyBudgetData(
          month: _shortMonthLabel(date),
          budget: budget,
          actual: actual,
        ),
      );
    }
    return result;
  }

  List<CategoryExpense> _buildCategoryExpenses(
    Iterable<TransactionModel> transactions,
  ) {
    final totals = <String, double>{};
    for (final tx in transactions) {
      totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries.map((e) {
      final style = _categoryStyle(e.key);
      return CategoryExpense(
        category: e.key,
        amount: e.value,
        color: style.color,
        icon: style.icon,
      );
    }).toList();
  }

  double _budgetForMonth(BudgetModel budget, DateTime month) {
    switch (budget.cycle) {
      case BudgetCycle.weekly:
        return budget.limitAmount * 4;
      case BudgetCycle.yearly:
        return budget.limitAmount / 12;
      case BudgetCycle.monthly:
        return budget.limitAmount;
    }
  }

  String _monthKey(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}';

  String _monthLabel(DateTime date) {
    final name = _monthNames[date.month - 1];
    return '$name ${date.year}';
  }

  String _shortMonthLabel(DateTime date) {
    final name = _shortMonthNames[date.month - 1];
    return name;
  }

  _CategoryStyle _categoryStyle(String category) {
    switch (category.toLowerCase()) {
      case 'necessities':
      case 'housing':
        return const _CategoryStyle(
          color: Color(0xFF4CAF50),
          icon: Icons.home_rounded,
        );
      case 'education':
        return const _CategoryStyle(
          color: Color(0xFFFFC94D),
          icon: Icons.school_rounded,
        );
      case 'long-term savings':
      case 'long_term_savings':
        return const _CategoryStyle(
          color: Color(0xFF26C6DA),
          icon: Icons.account_balance_rounded,
        );
      case 'entertainment':
        return const _CategoryStyle(
          color: Color(0xFFFF6B93),
          icon: Icons.celebration_rounded,
        );
      case 'give':
        return const _CategoryStyle(
          color: Color(0xFFAB47BC),
          icon: Icons.volunteer_activism_rounded,
        );
      case 'financial freedom':
      case 'financial_freedom':
        return const _CategoryStyle(
          color: Color(0xFF5B4EFF),
          icon: Icons.trending_up_rounded,
        );
      case 'income':
      case 'incoming':
        return const _CategoryStyle(
          color: Color(0xFF00D09E),
          icon: Icons.arrow_upward_rounded,
        );
      default:
        return const _CategoryStyle(
          color: Color(0xFF607D8B),
          icon: Icons.more_horiz_rounded,
        );
    }
  }
}

class _CategoryStyle {
  final Color color;
  final IconData icon;

  const _CategoryStyle({
    required this.color,
    required this.icon,
  });
}

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _shortMonthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
