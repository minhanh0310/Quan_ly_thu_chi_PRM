import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/transaction_bottom_sheet.dart';

class SliverQuickActionsWidget extends StatelessWidget {
  const SliverQuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPad.h20,
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Quick Actions',
              style: AppTextStyle.s16in.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.primaryTextColor,
              ),
            ),

            AppGap.h15,

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: IconPath.arrowUpRight,
                  label: 'INCOME',
                  color: const Color(0xFF00D09E),
                  backgroundColor: const Color(0xFFE8F8F4),
                  onTap: () =>
                      showAddTransactionBottomSheet(context, isIncome: true),
                ),
                _ActionButton(
                  icon: IconPath.arrowDownLeft,
                  label: 'EXPENSE',
                  color: const Color(0xFFFF6B93),
                  backgroundColor: const Color(0xFFFFE8EE),
                  onTap: () =>
                      showAddTransactionBottomSheet(context, isIncome: false),
                ),
                _ActionButton(
                  icon: IconPath.plus,
                  label: 'NEW PLAN',
                  color: context.primaryColor,
                  backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                  onTap: () {
                    print('====> Create Plan');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppBorderRadius.a20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              height: 15,
              width: 15,
            ),
            AppGap.h10,
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyle.s12in.copyWith(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
