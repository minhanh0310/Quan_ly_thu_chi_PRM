import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/savings_goal_model.dart';

class SavingsGoalsTabWidget extends StatelessWidget {
  const SavingsGoalsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final goals = SavingsGoalModel.mockList;
    final activeGoals = goals.where((g) => g.status == SavingsGoalStatus.active).toList();
    final completedGoals = goals.where((g) => g.status == SavingsGoalStatus.completed).toList();
    final overdueGoals = goals.where((g) => g.status == SavingsGoalStatus.overdue).toList();
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: AppGap.h20),
        
        // Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: _SavingsSummaryCard(goals: goals),
          ),
        ),
        
        // Section Header - Active Goals
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Goals',
                  style: AppTextStyle.s16in.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    print('====> Add new savings goal');
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
        
        // Active Goals List
        if (activeGoals.isNotEmpty)
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = activeGoals[index];
                  return Padding(
                    padding: AppPad.b16,
                    child: _SavingsGoalCard(
                      goal: goal,
                      onAllocate: () => _showAllocateDialog(context, goal),
                    ),
                  );
                },
                childCount: activeGoals.length,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: _EmptyStateCard(
                icon: Icons.savings_outlined,
                message: 'No active savings goals',
              ),
            ),
          ),
        
        // Overdue Goals
        if (overdueGoals.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: Text(
                'Overdue Goals',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.expenseRed,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = overdueGoals[index];
                  return Padding(
                    padding: AppPad.b16,
                    child: _SavingsGoalCard(
                      goal: goal,
                      onAllocate: () => _showAllocateDialog(context, goal),
                    ),
                  );
                },
                childCount: overdueGoals.length,
              ),
            ),
          ),
        ],
        
        // Completed Goals
        if (completedGoals.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: Text(
                'Completed Goals',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.incomeGreen,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = completedGoals[index];
                  return Padding(
                    padding: AppPad.b16,
                    child: _SavingsGoalCard(
                      goal: goal,
                      onAllocate: null,
                    ),
                  );
                },
                childCount: completedGoals.length,
              ),
            ),
          ),
        ],
        
        SliverToBoxAdapter(child: AppGap.h100),
      ],
    );
  }
  
  void _showAllocateDialog(BuildContext context, SavingsGoalModel goal) {
    final controller = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: AppPad.a20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppGap.h20,
              Text(
                'Add to "${goal.name}"',
                style: AppTextStyle.s18in.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppGap.h8,
              Text(
                'Target: ${_formatCurrency(goal.targetAmount)}',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Current: ${_formatCurrency(goal.currentAmount)}',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppGap.h20,
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount to save',
                  prefixText: 'VND ',
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a12,
                  ),
                ),
              ),
              AppGap.h20,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: AppPad.v14,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.a12,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  AppGap.w12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('====> Allocate: ${controller.text}');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: AppColors.white,
                        padding: AppPad.v14,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.a12,
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
              AppGap.h20,
            ],
          ),
        ),
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

class _SavingsSummaryCard extends StatelessWidget {
  final List<SavingsGoalModel> goals;

  const _SavingsSummaryCard({required this.goals});

  @override
  Widget build(BuildContext context) {
    final totalTarget = goals.fold<double>(0, (sum, g) => sum + g.targetAmount);
    final totalSaved = goals.fold<double>(0, (sum, g) => sum + g.currentAmount);
    final totalRemaining = totalTarget - totalSaved;
    final activeCount = goals.where((g) => g.status == SavingsGoalStatus.active).length;
    final completedCount = goals.where((g) => g.status == SavingsGoalStatus.completed).length;

    return Container(
      padding: AppPad.a20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.incomeGreen,
            AppColors.incomeGreen.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.a20,
        boxShadow: [
          BoxShadow(
            color: AppColors.incomeGreen.withValues(alpha: 0.3),
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
                'Total Savings',
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
                  '$activeCount Active',
                  style: AppTextStyle.s12in.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          AppGap.h12,
          Text(
            _formatCurrency(totalSaved),
            style: AppTextStyle.s32in.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGap.h4,
          Text(
            '${_formatCurrency(totalRemaining)} remaining to reach all goals',
            style: AppTextStyle.s14in.copyWith(
              color: Colors.white70,
            ),
          ),
          AppGap.h16,
          Row(
            children: [
              _StatItem(
                icon: Icons.flag_rounded,
                label: 'Active',
                value: '$activeCount',
              ),
              AppGap.w24,
              _StatItem(
                icon: Icons.check_circle_rounded,
                label: 'Completed',
                value: '$completedCount',
              ),
              AppGap.w24,
              _StatItem(
                icon: Icons.trending_up_rounded,
                label: 'Target',
                value: _formatCurrencyShort(totalTarget),
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
  
  String _formatCurrencyShort(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)}M';
    }
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        AppGap.w4,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyle.s14in.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyle.s10in.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SavingsGoalCard extends StatelessWidget {
  final SavingsGoalModel goal;
  final VoidCallback? onAllocate;

  const _SavingsGoalCard({
    required this.goal,
    this.onAllocate,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (goal.status) {
      case SavingsGoalStatus.completed:
        statusColor = AppColors.incomeGreen;
        statusText = 'Completed';
        break;
      case SavingsGoalStatus.overdue:
        statusColor = AppColors.expenseRed;
        statusText = 'Overdue';
        break;
      case SavingsGoalStatus.active:
        statusColor = AppColors.primaryPurple;
        statusText = 'Active';
        break;
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
                padding: AppPad.a12,
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.a12,
                ),
                child: Icon(
                  goal.icon,
                  color: goal.color,
                  size: 28,
                ),
              ),
              AppGap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: AppTextStyle.s16in.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (goal.description != null)
                      Text(
                        goal.description!,
                        style: AppTextStyle.s12in.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding: AppPad.h8v4,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: AppBorderRadius.a8,
                ),
                child: Text(
                  statusText,
                  style: AppTextStyle.s12in.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          AppGap.h16,
          
          // Progress Bar with percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppBorderRadius.a4,
                  child: LinearProgressIndicator(
                    value: goal.progressPercent,
                    backgroundColor: AppColors.lightGrayBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                    minHeight: 10,
                  ),
                ),
              ),
              AppGap.w12,
              SizedBox(
                width: 50,
                child: Text(
                  '${(goal.progressPercent * 100).toInt()}%',
                  style: AppTextStyle.s14in.copyWith(
                    fontWeight: FontWeight.bold,
                    color: goal.color,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
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
                    'Saved',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(goal.currentAmount),
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.incomeGreen,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Target',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(goal.targetAmount),
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
                    'Remaining',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(goal.remainingAmount),
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Deadline & Monthly Suggestion
          AppGap.h12,
          Container(
            padding: AppPad.a12,
            decoration: BoxDecoration(
              color: AppColors.lightGrayBackground,
              borderRadius: AppBorderRadius.a8,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: goal.isOverdue ? AppColors.expenseRed : AppColors.textSecondary,
                ),
                AppGap.w8,
                Expanded(
                  child: Text(
                    goal.isOverdue 
                        ? 'Deadline: ${_formatDate(goal.deadline)} (Overdue)'
                        : 'Deadline: ${_formatDate(goal.deadline)}',
                    style: AppTextStyle.s12in.copyWith(
                      color: goal.isOverdue ? AppColors.expenseRed : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (!goal.isCompleted && !goal.isOverdue) ...[
                  Container(
                    width: 1,
                    height: 16,
                    color: AppColors.grey.withValues(alpha: 0.3),
                  ),
                  AppGap.w8,
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: AppColors.accentYellow,
                  ),
                  AppGap.w4,
                  Text(
                    '${_formatCurrencyShort(goal.monthlyRequired)}/month',
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Allocate Button
          if (onAllocate != null && !goal.isCompleted) ...[
            AppGap.h12,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAllocate,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Add Money'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: goal.color,
                  foregroundColor: AppColors.white,
                  padding: AppPad.v12,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.a12,
                  ),
                ),
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
  
  String _formatCurrencyShort(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyStateCard({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.a32,
      decoration: BoxDecoration(
        color: AppColors.lightGrayBackground,
        borderRadius: AppBorderRadius.a16,
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.grey.withValues(alpha: 0.5),
          ),
          AppGap.h12,
          Text(
            message,
            style: AppTextStyle.s14in.copyWith(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
