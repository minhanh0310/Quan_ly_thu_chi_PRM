import 'package:Quan_ly_thu_chi_PRM/init.dart';

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
                color: AppColors.text,
              ),
            ),

            AppGap.h15,

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.arrow_downward,
                  label: 'INCOME',
                  color: const Color(0xFF00D09E),
                  backgroundColor: const Color(0xFFE8F8F4),
                  onTap: () {
                    // TODO: Navigate to add income screen
                    print('====> Add Income');
                  },
                ),
                _ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'EXPENSE',
                  color: const Color(0xFFFF6B93),
                  // TODO: Move to AppColors.expenseRed
                  backgroundColor: const Color(0xFFFFE8EE),
                  onTap: () {
                    // TODO: Navigate to add expense screen
                    print('====> Add Expense');
                  },
                ),
                _ActionButton(
                  icon: Icons.add,
                  label: 'NEW PLAN',
                  color: AppColors.primaryPurple,
                  backgroundColor: const Color(0xFFF0EDFF),
                  onTap: () {
                    // TODO: Navigate to create plan screen
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

/// Action Button Component - Fixed size 100x100
class _ActionButton extends StatelessWidget {
  final IconData icon;
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
            Icon(icon, color: color, size: 28),
            AppGap.h8,
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyle.s12in.copyWith(
                fontSize: 11,
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
