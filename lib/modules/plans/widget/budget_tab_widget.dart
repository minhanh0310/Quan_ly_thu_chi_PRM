import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/budget_model.dart';

class BudgetTabWidget extends StatelessWidget {
  const BudgetTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final budgets = BudgetModel.mockList;
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: AppGap.h20),
        
        // Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: _BudgetSummaryCard(budgets: budgets),
          ),
        ),
        
        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Categories',
                  style: AppTextStyle.s16in.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    print('====> Add new budget');
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Budget List
        SliverPadding(
          padding: AppPad.h20,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final budget = budgets[index];
                return Padding(
                  padding: AppPad.b16,
                  child: _BudgetCard(budget: budget),
                );
              },
              childCount: budgets.length,
            ),
          ),
        ),
        
        SliverToBoxAdapter(child: AppGap.h100),
      ],
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  final List<BudgetModel> budgets;

  const _BudgetSummaryCard({required this.budgets});

  @override
  Widget build(BuildContext context) {
    final totalLimit = budgets.fold<double>(0, (sum, b) => sum + b.limitAmount);
    final totalSpent = budgets.fold<double>(0, (sum, b) => sum + b.spentAmount);
    final totalRemaining = totalLimit - totalSpent;
    final percentUsed = totalLimit > 0 ? totalSpent / totalLimit : 0.0;
    
    Color statusColor;
    if (percentUsed >= 1.0) {
      statusColor = AppColors.expenseRed;
    } else if (percentUsed >= 0.8) {
      statusColor = AppColors.accentYellow;
    } else {
      statusColor = AppColors.incomeGreen;
    }

    return Container(
      padding: AppPad.a20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple,
            AppColors.primaryPurpleDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.a20,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Budget',
                style: AppTextStyle.s14in.copyWith(
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: AppPad.h8v4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppBorderRadius.a12,
                ),
                child: Text(
                  'This Month',
                  style: AppTextStyle.s12in.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          AppGap.h12,
          Text(
            _formatCurrency(totalRemaining),
            style: AppTextStyle.s32in.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGap.h4,
          Text(
            totalRemaining >= 0 
                ? 'Remaining of ${_formatCurrency(totalLimit)}'
                : 'Over budget by ${_formatCurrency(-totalRemaining)}',
            style: AppTextStyle.s14in.copyWith(
              color: Colors.white70,
            ),
          ),
          AppGap.h16,
          ClipRRect(
            borderRadius: AppBorderRadius.a4,
            child: LinearProgressIndicator(
              value: percentUsed.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 8,
            ),
          ),
          AppGap.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percentUsed * 100).toInt()}% used',
                style: AppTextStyle.s12in.copyWith(
                  color: Colors.white70,
                ),
              ),
              Text(
                '${_formatCurrency(totalSpent)} spent',
                style: AppTextStyle.s12in.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VND';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VND';
    }
    return '${amount.toStringAsFixed(0)} VND';
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetModel budget;

  const _BudgetCard({required this.budget});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    if (budget.isOverspent) {
      statusColor = AppColors.expenseRed;
      statusIcon = Icons.warning_rounded;
    } else if (budget.isWarning) {
      statusColor = AppColors.accentYellow;
      statusIcon = Icons.info_rounded;
    } else {
      statusColor = AppColors.incomeGreen;
      statusIcon = Icons.check_circle_rounded;
    }

    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderRadius.a16,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: AppPad.a10,
                decoration: BoxDecoration(
                  color: budget.categoryColor.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.a12,
                ),
                child: Icon(
                  budget.categoryIcon,
                  color: budget.categoryColor,
                  size: 24,
                ),
              ),
              AppGap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.categoryName,
                      style: AppTextStyle.s16in.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        _ExpenseTypeChip(type: budget.expenseType),
                        AppGap.w8,
                        _CycleChip(cycle: budget.cycle),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  Text(
                    '${(budget.percentUsed * 100).toInt()}%',
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          AppGap.h16,
          
          // Progress Bar
          ClipRRect(
            borderRadius: AppBorderRadius.a4,
            child: LinearProgressIndicator(
              value: budget.percentUsed.clamp(0.0, 1.0),
              backgroundColor: AppColors.lightGrayBackground,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 8,
            ),
          ),
          
          AppGap.h12,
          
          // Amount Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(budget.spentAmount),
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: budget.isOverspent 
                          ? AppColors.expenseRed 
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Budget',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(budget.limitAmount),
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    budget.isOverspent ? 'Overspent' : 'Remaining',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(budget.remainingAmount.abs()),
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: budget.isOverspent 
                          ? AppColors.expenseRed 
                          : AppColors.incomeGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Overspent Warning
          if (budget.isOverspent) ...[
            AppGap.h12,
            Container(
              padding: AppPad.a12,
              decoration: BoxDecoration(
                color: AppColors.expenseLightRed,
                borderRadius: AppBorderRadius.a8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: AppColors.expenseRed,
                    size: 20,
                  ),
                  AppGap.w8,
                  Expanded(
                    child: Text(
                      'You\'ve exceeded your budget! Consider reducing expenses in this category.',
                      style: AppTextStyle.s12in.copyWith(
                        color: AppColors.expenseRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _ExpenseTypeChip extends StatelessWidget {
  final ExpenseType type;

  const _ExpenseTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final isFixed = type == ExpenseType.fixed;
    return Container(
      padding: AppPad.h6v2,
      decoration: BoxDecoration(
        color: isFixed 
            ? AppColors.primaryPurpleLight 
            : AppColors.accentYellow.withValues(alpha: 0.2),
        borderRadius: AppBorderRadius.a4,
      ),
      child: Text(
        isFixed ? 'Fixed' : 'Variable',
        style: AppTextStyle.s10in.copyWith(
          color: isFixed ? AppColors.primaryPurple : AppColors.accentYellow,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CycleChip extends StatelessWidget {
  final BudgetCycle cycle;

  const _CycleChip({required this.cycle});

  @override
  Widget build(BuildContext context) {
    String label;
    switch (cycle) {
      case BudgetCycle.weekly:
        label = 'Weekly';
        break;
      case BudgetCycle.monthly:
        label = 'Monthly';
        break;
      case BudgetCycle.yearly:
        label = 'Yearly';
        break;
    }
    
    return Container(
      padding: AppPad.h6v2,
      decoration: BoxDecoration(
        color: AppColors.lightGrayBackground,
        borderRadius: AppBorderRadius.a4,
      ),
      child: Text(
        label,
        style: AppTextStyle.s10in.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
