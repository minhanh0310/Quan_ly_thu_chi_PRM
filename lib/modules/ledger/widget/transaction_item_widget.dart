import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/category_tr.dart';

class TransactionItemWidget extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String category;
  final String? tag;
  final bool isIncome;

  const TransactionItemWidget({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
    this.tag,
    required this.isIncome,
  });

  static Color _categoryColor(String category) {
    final key = category.startsWith('tags.')
        ? category.substring(5)
        : category.toLowerCase();
    switch (key) {
      case 'necessities':
        return const Color(0xFF4CAF50);
      case 'financial_freedom':
        return const Color(0xFF5B4EFF);
      case 'education':
        return const Color(0xFFFFC94D);
      case 'long_term_savings':
        return const Color(0xFF26C6DA);
      case 'entertainment':
        return const Color(0xFFFF6B93);
      case 'give':
        return const Color(0xFFAB47BC);
      case 'income':
        return const Color(0xFF00D09E);
      case 'plan':
        return const Color(0xFF6C5CE7);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.b10,
      // margin: const EdgeInsets.only(bottom: 15),
      padding: AppPad.a10,
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: AppBorderRadius.a16,
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
          Container(
            padding: AppPad.a18,
            decoration: BoxDecoration(
              color: isIncome
                  ? AppColors.incomeLightGreen
                  : AppColors.expenseLightRed,
              borderRadius: AppBorderRadius.a12,
            ),
            child: SvgPicture.asset(
              isIncome ? IconPath.arrowUpRight : IconPath.arrowDownLeft,
              colorFilter: isIncome
                  ? ColorFilter.mode(context.incomeColor, BlendMode.srcIn)
                  : ColorFilter.mode(context.expenseColor, BlendMode.srcIn),
              height: 15,
              width: 15,
            ),
          ),

          AppGap.w12,

          // Transaction info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title.trCategory(),
                  style: AppTextStyle.s16in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),

                AppGap.h4,

                // Date, category, tag row
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Date
                    Text(
                      date,
                      style: AppTextStyle.s12in.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),

                    // Income / Expense badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isIncome
                            ? AppColors.incomeGreen.withValues(alpha: 0.12)
                            : AppColors.expenseRed.withValues(alpha: 0.12),
                        borderRadius: AppBorderRadius.a8,
                      ),
                      child: Text(
                        isIncome
                            ? 'home_screen.income'.tr().toUpperCase()
                            : 'home_screen.expense'.tr().toUpperCase(),
                        style: AppTextStyle.s12in.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isIncome
                              ? AppColors.incomeGreen
                              : AppColors.expenseRed,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    // Tag (if exists)
                    if (tag != null && tag!.isNotEmpty)
                      Text(
                        '#$tag',
                        style: AppTextStyle.s12in.copyWith(
                          fontSize: 11,
                          color: context.secondaryTextColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: AppTextStyle.s16in.copyWith(
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF00D09E)
                  : const Color(0xFFFF6B93),
            ),
          ),
        ],
      ),
    );
  }
}
