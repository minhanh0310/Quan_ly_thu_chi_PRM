import 'package:Quan_ly_thu_chi_PRM/init.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.b10,
      // margin: const EdgeInsets.only(bottom: 15),
      padding: AppPad.a10,
      decoration: BoxDecoration(
        color: AppColors.lightGrayBackground,
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
                  ? const Color(0xFFE8F8F4)
                  : const Color(0xFFFFE8EE),
              borderRadius: AppBorderRadius.a12,
            ),
            child: SvgPicture.asset(
              isIncome ? IconPath.arrowDownLeft : IconPath.arrowUpRight,
              colorFilter: isIncome
                  ? const ColorFilter.mode(Color(0xFF00D09E), BlendMode.srcIn)
                  : const ColorFilter.mode(Color(0xFFFF6B93), BlendMode.srcIn),
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
                  title,
                  style: AppTextStyle.s16in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
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
                      style: AppTextStyle.s12in.copyWith(color: AppColors.grey),
                    ),

                    // Category badge (if exists)
                    if (category.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                          borderRadius: AppBorderRadius.a8,
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: AppTextStyle.s12in.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6C5CE7),
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
                          color: AppColors.grey,
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
