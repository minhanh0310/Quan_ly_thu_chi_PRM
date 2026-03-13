import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:Quan_ly_thu_chi_PRM/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

/// Recent Activity Widget - Sử dụng theme constants và SliverList
class SliverRecentActivityWidget extends StatelessWidget {
  const SliverRecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final cp = context.read<CurrencyProvider>();
    final service = FinanceDatabaseService();

    return SliverPadding(
      padding: AppPad.h20,
      sliver: StreamBuilder<List<TransactionModel>>(
        stream: uid == null ? Stream.empty() : service.watchTransactions(uid),
        builder: (context, snapshot) {
          final items = snapshot.data ?? const [];
          final recent = items.take(4).toList();
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == 0) {
                return Text(
                  'home_screen.recent_activity'.tr(),
                  style: AppTextStyle.s16in.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.primaryTextColor,
                  ),
                );
              }
              if (recent.isEmpty) {
                if (index == 1) {
                  return Padding(
                    padding: AppPad.v10,
                    child: Text(
                      'home_screen.no_activity'.tr(),
                      style: AppTextStyle.s12in.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  );
                }
                return null;
              }
              final activityIndex = index - 1;
              if (activityIndex >= recent.length) {
                return null;
              }
              final activity = recent[activityIndex];
              final isIncome = activity.isIncome;
              final icon = isIncome ? IconPath.arrowUpRight : IconPath.arrowDownLeft;
              final iconColor =
                  isIncome ? AppColors.incomeGreen : AppColors.expenseRed;
              final bgColor =
                  isIncome ? AppColors.incomeLightGreen : AppColors.expenseLightRed;
              final date =
                  '${activity.date.year}-${activity.date.month.toString().padLeft(2, '0')}-${activity.date.day.toString().padLeft(2, '0')}';
              final formatted =
                  '${isIncome ? '+' : '-'}${cp.formatCurrency(activity.amount)}';
              return _ActivityItem(
                icon: icon,
                iconColor: iconColor,
                backgroundColor: bgColor,
                title: activity.title,
                date: date,
                amount: formatted,
                isIncome: isIncome,
              );
            }, childCount: recent.isEmpty ? 2 : recent.length + 1),
          );
        },
      ),
    );
  }
}

/// Activity Item Component
class _ActivityItem extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.b10,
      padding: AppPad.a8,
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: AppBorderRadius.a12,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: AppPad.a18,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: AppBorderRadius.a12,
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              height: 15,
              width: 15,
            ),
          ),

          AppGap.w12,

          // Activity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.s14in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                AppGap.h4,
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.s12in.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: AppTextStyle.s16in.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
