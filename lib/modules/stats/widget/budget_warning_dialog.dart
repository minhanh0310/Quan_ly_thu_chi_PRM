import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/model/stats_model.dart';

/// Dialog widget to show budget warning when expenses exceed budget
class BudgetWarningDialog extends StatelessWidget {
  final double currentExpense;
  final double budget;
  final double newExpenseAmount;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const BudgetWarningDialog({
    super.key,
    required this.currentExpense,
    required this.budget,
    required this.newExpenseAmount,
    this.onConfirm,
    this.onCancel,
  });

  /// Show budget warning dialog
  /// Returns true if user confirms, false otherwise
  static Future<bool> show({
    required BuildContext context,
    required double currentExpense,
    required double budget,
    required double newExpenseAmount,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BudgetWarningDialog(
        currentExpense: currentExpense,
        budget: budget,
        newExpenseAmount: newExpenseAmount,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
    return result ?? false;
  }

  /// Check if adding new expense would exceed budget
  static bool willExceedBudget({
    required double currentExpense,
    required double budget,
    required double newExpenseAmount,
  }) {
    return (currentExpense + newExpenseAmount) > budget;
  }

  /// Calculate how much over budget
  static double calculateOverBudgetAmount({
    required double currentExpense,
    required double budget,
    required double newExpenseAmount,
  }) {
    final totalAfter = currentExpense + newExpenseAmount;
    if (totalAfter > budget) {
      return totalAfter - budget;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final totalAfter = currentExpense + newExpenseAmount;
    final overAmount = totalAfter - budget;
    final percentage = (totalAfter / budget) * 100;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: AppPad.h24,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.expenseRed.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.expenseRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppColors.expenseRed,
                size: 40,
              ),
            ),
            AppGap.h20,

            // Title
            Text(
              'Budget exceeded!',
              style: AppTextStyle.s20.copyWith(
                color: AppColors.expenseRed,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppGap.h12,

            // Description
            Text(
              'This new expense will make your total spending exceed the budget.',
              style: AppTextStyle.s14in.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            AppGap.h20,

            // Stats
            Container(
              padding: AppPad.h16,
              decoration: BoxDecoration(
                color: context.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStatRow(
                    'Current budget:',
                    '\$${budget.toStringAsFixed(0)}',
                    context.secondaryTextColor,
                  ),
                  AppGap.h8,
                  _buildStatRow(
                    'Current spending:',
                    '\$${currentExpense.toStringAsFixed(0)}',
                    context.secondaryTextColor,
                  ),
                  AppGap.h8,
                  _buildStatRow(
                    'New expense:',
                    '-\$${newExpenseAmount.toStringAsFixed(0)}',
                    AppColors.expenseRed,
                  ),
                  const Divider(height: 16),
                  _buildStatRow(
                    'Total after adding:',
                    '\$${totalAfter.toStringAsFixed(0)} (${percentage.toStringAsFixed(0)}%)',
                    AppColors.expenseRed,
                    isBold: true,
                  ),
                  AppGap.h8,
                  _buildStatRow(
                    'Over budget:',
                    '+\$${overAmount.toStringAsFixed(0)}',
                    AppColors.expenseRed,
                    isBold: true,
                  ),
                ],
              ),
            ),
            AppGap.h24,

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: context.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyle.s16.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                  ),
                ),
                AppGap.w12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.expenseRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add anyway',
                      style: AppTextStyle.s16.copyWith(
                        color: context.surfaceColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.s14in.copyWith(
            color: valueColor,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.s14.copyWith(
            color: valueColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Simple inline warning banner widget
class BudgetWarningBanner extends StatelessWidget {
  final double percentage;
  final VoidCallback? onTap;

  const BudgetWarningBanner({
    super.key,
    required this.percentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(percentage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPad.h16,
        decoration: BoxDecoration(
          color: _getStatusColor(status).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor(status).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(status),
              color: _getStatusColor(status),
              size: 24,
            ),
            AppGap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusTitle(status),
                    style: AppTextStyle.s14.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getStatusMessage(status),
                    style: AppTextStyle.s12in.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: _getStatusColor(status),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  BudgetStatus _getStatus(double percentage) {
    if (percentage >= 100) return BudgetStatus.overSpent;
    if (percentage >= 80) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }

  Color _getStatusColor(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return AppColors.green;
      case BudgetStatus.warning:
        return AppColors.accentYellow;
      case BudgetStatus.overSpent:
        return AppColors.expenseRed;
    }
  }

  IconData _getStatusIcon(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return Icons.check_circle_rounded;
      case BudgetStatus.warning:
        return Icons.warning_rounded;
      case BudgetStatus.overSpent:
        return Icons.error_rounded;
    }
  }

  String _getStatusTitle(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return 'Budget is safe';
      case BudgetStatus.warning:
        return 'Budget warning';
      case BudgetStatus.overSpent:
        return 'Over budget!';
    }
  }

  String _getStatusMessage(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return 'You have used less than 80% of your budget';
      case BudgetStatus.warning:
        return 'You have used 80–100% of your budget';
      case BudgetStatus.overSpent:
        return 'Your spending has exceeded the budget!';
    }
  }
}
