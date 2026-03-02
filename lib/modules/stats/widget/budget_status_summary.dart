import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/model/stats_model.dart';

/// Widget displaying budget status summary with remaining/overspent amount
class BudgetStatusSummary extends StatelessWidget {
  final double budget;
  final double expense;
  final String currentMonth;

  const BudgetStatusSummary({
    super.key,
    required this.budget,
    required this.expense,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = budget - expense;
    final percentage = budget > 0 ? (expense / budget) * 100 : 0.0;
    final isOverSpent = expense > budget;
    final status = _getStatus(percentage);

    return Container(
      padding: AppPad.h20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(status).withValues(alpha: 0.15),
            _getStatusColor(status).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonth,
                style: AppTextStyle.s16in.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildStatusBadge(status),
            ],
          ),
          AppGap.h16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOverSpent ? 'Overspent Amount' : 'Remaining Amount',
                      style: AppTextStyle.s14in.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppGap.h4,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOverSpent ? '-\$' : '+\$',
                          style: AppTextStyle.s20.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          remaining.abs().toStringAsFixed(0),
                          style: AppTextStyle.s28.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Spent',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    '\$${expense.toStringAsFixed(0)}',
                    style: AppTextStyle.s20.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'of \$${budget.toStringAsFixed(0)}',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppGap.h16,
          _buildProgressBar(percentage, status),
          AppGap.h8,
          Text(
            '${percentage.toStringAsFixed(1)}% of budget used',
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BudgetStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            color: AppColors.white,
            size: 14,
          ),
          AppGap.w4,
          Text(
            _getStatusText(status),
            style: AppTextStyle.s12.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percentage, BudgetStatus status) {
    final clampedPercentage = percentage.clamp(0.0, 100.0).toDouble();
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            height: 12,
            width: double.infinity,
            color: AppColors.grey.withValues(alpha: 0.2),
          ),
          FractionallySizedBox(
            widthFactor: clampedPercentage / 100,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getStatusColor(status),
                    _getStatusColor(status).withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (percentage > 100)
            Positioned(
              right: 0,
              top: -4,
              child: Container(
                width: 2,
                height: 20,
                color: AppColors.expenseRed,
              ),
            ),
        ],
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

  String _getStatusText(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return 'Safe';
      case BudgetStatus.warning:
        return 'Warning';
      case BudgetStatus.overSpent:
        return 'Overspent';
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
}
