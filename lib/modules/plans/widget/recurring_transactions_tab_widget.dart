import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/recurring_transaction_model.dart';

class RecurringTransactionsTabWidget extends StatelessWidget {
  const RecurringTransactionsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = RecurringTransactionModel.mockList;
    final expenseTransactions = transactions.where((t) => !t.isIncome).toList();
    final incomeTransactions = transactions.where((t) => t.isIncome).toList();
    final dueSoonTransactions = transactions.where((t) => t.isDueSoon).toList();
    final overdueTransactions = transactions.where((t) => t.isOverdue).toList();
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: AppGap.h20),
        
        // Upcoming Payments Summary
        if (dueSoonTransactions.isNotEmpty || overdueTransactions.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: _UpcomingPaymentsCard(
                dueSoon: dueSoonTransactions,
                overdue: overdueTransactions,
              ),
            ),
          ),
        
        // Section Header - Expenses
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recurring Expenses',
                  style: AppTextStyle.s16in.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    print('====> Add new recurring transaction');
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
        
        // Expenses List
        if (expenseTransactions.isNotEmpty)
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = expenseTransactions[index];
                  return Padding(
                    padding: AppPad.b12,
                    child: _RecurringTransactionCard(transaction: transaction),
                  );
                },
                childCount: expenseTransactions.length,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: _EmptyStateCard(
                icon: Icons.receipt_long_outlined,
                message: 'No recurring expenses',
              ),
            ),
          ),
        
        // Section Header - Income
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: Text(
              'Recurring Income',
              style: AppTextStyle.s16in.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        
        // Income List
        if (incomeTransactions.isNotEmpty)
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = incomeTransactions[index];
                  return Padding(
                    padding: AppPad.b12,
                    child: _RecurringTransactionCard(transaction: transaction),
                  );
                },
                childCount: incomeTransactions.length,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: _EmptyStateCard(
                icon: Icons.attach_money_rounded,
                message: 'No recurring income',
              ),
            ),
          ),
        
        SliverToBoxAdapter(child: AppGap.h100),
      ],
    );
  }
}

class _UpcomingPaymentsCard extends StatelessWidget {
  final List<RecurringTransactionModel> dueSoon;
  final List<RecurringTransactionModel> overdue;

  const _UpcomingPaymentsCard({
    required this.dueSoon,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    final totalDueSoon = dueSoon.fold<double>(0, (sum, t) => sum + t.amount);
    final totalOverdue = overdue.fold<double>(0, (sum, t) => sum + t.amount);

    return Container(
      padding: AppPad.a20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: overdue.isNotEmpty
              ? [AppColors.expenseRed, AppColors.expenseRed.withValues(alpha: 0.8)]
              : [AppColors.accentYellow, AppColors.accentYellow.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.a20,
        boxShadow: [
          BoxShadow(
            color: (overdue.isNotEmpty ? AppColors.expenseRed : AppColors.accentYellow)
                .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                overdue.isNotEmpty 
                    ? Icons.warning_rounded 
                    : Icons.notifications_active_rounded,
                color: Colors.white,
                size: 24,
              ),
              AppGap.w12,
              Text(
                overdue.isNotEmpty 
                    ? 'Overdue Payments' 
                    : 'Upcoming Payments',
                style: AppTextStyle.s18in.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppGap.h16,
          if (overdue.isNotEmpty) ...[
            Text(
              '${overdue.length} payment(s) overdue',
              style: AppTextStyle.s14in.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'Total: ${_formatCurrency(totalOverdue)}',
              style: AppTextStyle.s16in.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Text(
              '${dueSoon.length} payment(s) due within 3 days',
              style: AppTextStyle.s14in.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'Total: ${_formatCurrency(totalDueSoon)}',
              style: AppTextStyle.s16in.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          AppGap.h16,
          // Quick list of due items
          Container(
            constraints: const BoxConstraints(maxHeight: 80),
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: overdue.isNotEmpty ? overdue.length : dueSoon.length,
              separatorBuilder: (_, __) => AppGap.w8,
              itemBuilder: (context, index) {
                final item = overdue.isNotEmpty ? overdue[index] : dueSoon[index];
                return Container(
                  padding: AppPad.a12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppBorderRadius.a12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyle.s12in.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatCurrency(item.amount),
                        style: AppTextStyle.s14in.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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

class _RecurringTransactionCard extends StatelessWidget {
  final RecurringTransactionModel transaction;

  const _RecurringTransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        children: [
          // Category Icon
          Container(
            padding: AppPad.a12,
            decoration: BoxDecoration(
              color: transaction.categoryColor.withValues(alpha: 0.1),
              borderRadius: AppBorderRadius.a12,
            ),
            child: Icon(
              transaction.categoryIcon,
              color: transaction.categoryColor,
              size: 24,
            ),
          ),
          
          AppGap.w12,
          
          // Transaction Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.title,
                        style: AppTextStyle.s16in.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Recurring Badge
                    Container(
                      padding: AppPad.h6v2,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurpleLight,
                        borderRadius: AppBorderRadius.a4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.repeat_rounded,
                            size: 12,
                            color: AppColors.primaryPurple,
                          ),
                          AppGap.w2,
                          Text(
                            transaction.cycleLabel,
                            style: AppTextStyle.s10in.copyWith(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppGap.h4,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: transaction.isOverdue 
                          ? AppColors.expenseRed 
                          : transaction.isDueSoon 
                              ? AppColors.accentYellow 
                              : AppColors.textTertiary,
                    ),
                    AppGap.w4,
                    Text(
                      transaction.isOverdue 
                          ? 'Overdue: ${_formatDate(transaction.nextDueDate)}'
                          : 'Next: ${_formatDate(transaction.nextDueDate)}',
                      style: AppTextStyle.s12in.copyWith(
                        color: transaction.isOverdue 
                            ? AppColors.expenseRed 
                            : transaction.isDueSoon 
                                ? AppColors.accentYellow 
                                : AppColors.textTertiary,
                      ),
                    ),
                    if (transaction.isDueSoon && !transaction.isOverdue) ...[
                      AppGap.w8,
                      Container(
                        padding: AppPad.h4v2,
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withValues(alpha: 0.2),
                          borderRadius: AppBorderRadius.a4,
                        ),
                        child: Text(
                          'Due Soon',
                          style: AppTextStyle.s10in.copyWith(
                            color: AppColors.accentYellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (transaction.isOverdue) ...[
                      AppGap.w8,
                      Container(
                        padding: AppPad.h4v2,
                        decoration: BoxDecoration(
                          color: AppColors.expenseLightRed,
                          borderRadius: AppBorderRadius.a4,
                        ),
                        child: Text(
                          'Overdue',
                          style: AppTextStyle.s10in.copyWith(
                            color: AppColors.expenseRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (transaction.notes != null) ...[
                  AppGap.h4,
                  Text(
                    transaction.notes!,
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          
          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.isIncome 
                    ? '+${_formatCurrency(transaction.amount)}'
                    : '-${_formatCurrency(transaction.amount)}',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.bold,
                  color: transaction.isIncome 
                      ? AppColors.incomeGreen 
                      : AppColors.expenseRed,
                ),
              ),
              AppGap.h4,
              // Toggle Switch for active/inactive
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: transaction.isActive,
                  onChanged: (value) {
                    print('====> Toggle ${transaction.title}: $value');
                  },
                  activeTrackColor: AppColors.primaryPurple.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primaryPurple,
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
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
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
