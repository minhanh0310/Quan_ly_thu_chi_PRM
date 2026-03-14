import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:Quan_ly_thu_chi_PRM/models/transaction_model.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverJarsBalanceCardWidget extends StatelessWidget {
  final double totalBalance;

  const SliverJarsBalanceCardWidget({super.key, required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final service = FinanceDatabaseService();
    final formattedBalance = context.read<CurrencyProvider>().formatCurrency(
      totalBalance,
    );
    final now = DateTime.now();
    final currentMonthKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final previousMonthDate = DateTime(now.year, now.month - 1, 1);
    final previousMonthKey =
        '${previousMonthDate.year}-${previousMonthDate.month.toString().padLeft(2, '0')}';
    return Container(
      padding: AppPad.a20,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPurple, AppColors.primaryPurpleDark],
        ),
        borderRadius: AppBorderRadius.a20,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'jars_screen.total_assets'.tr(),
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          AppGap.h6,
          Text(
            formattedBalance,
            style: AppTextStyle.s28in.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          AppGap.h12,
          StreamBuilder<List<TransactionModel>>(
            stream: uid == null ? Stream.empty() : service.watchTransactions(uid),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              double currentIncome = 0;
              double currentExpense = 0;
              double previousIncome = 0;
              double previousExpense = 0;
              for (final t in items) {
                final key =
                    '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
                if (key == currentMonthKey) {
                  if (t.isIncome) {
                    currentIncome += t.amount;
                  } else {
                    currentExpense += t.amount;
                  }
                } else if (key == previousMonthKey) {
                  if (t.isIncome) {
                    previousIncome += t.amount;
                  } else {
                    previousExpense += t.amount;
                  }
                }
              }
              final incomeDeltaPct = previousIncome <= 0
                  ? (currentIncome > 0 ? 100.0 : 0.0)
                  : ((currentIncome - previousIncome) / previousIncome) * 100;
              final expenseDeltaPct = previousExpense <= 0
                  ? (currentExpense > 0 ? 100.0 : 0.0)
                  : ((currentExpense - previousExpense) / previousExpense) * 100;
              final incomeLabel =
                  '${incomeDeltaPct >= 0 ? '+' : ''}${incomeDeltaPct.toStringAsFixed(1)}%';
              final expenseLabel =
                  '${expenseDeltaPct >= 0 ? '+' : ''}${expenseDeltaPct.toStringAsFixed(1)}%';
              return Row(
                children: [
                  _Badge(
                    label: 'jars_screen.cash_in'.tr(),
                    value: incomeLabel,
                    icon: Icons.trending_up_rounded,
                    color: AppColors.incomeGreen,
                  ),
                  AppGap.w20,
                  _Badge(
                    label: 'jars_screen.cash_out'.tr(),
                    value: expenseLabel,
                    icon: Icons.trending_down_rounded,
                    color: AppColors.expenseRed,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _Badge({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.h12v4,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: AppBorderRadius.a10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.lightGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppGap.h5,
          Row(
            children: [
              Icon(icon, color: color, size: 13),
              AppGap.w4,
              Text(
                value,
                style: AppTextStyle.s12in.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
