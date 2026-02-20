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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                    // TODO: Navigate to add income
                    print('====> Add Income');
                  },
                ),
                _ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'EXPENSE',
                  color: const Color(0xFFFF6B93),
                  backgroundColor: const Color(0xFFFFE8EE),
                  onTap: () {
                    // TODO: Navigate to add expense
                    print('====> Add Expense');
                  },
                ),
                _ActionButton(
                  icon: Icons.add,
                  label: 'NEW\nPLAN',
                  color: const Color(0xFF6C5CE7),
                  backgroundColor: const Color(0xFFF0EDFF),
                  onTap: () {
                    // TODO: Navigate to create plan
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 11,
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
