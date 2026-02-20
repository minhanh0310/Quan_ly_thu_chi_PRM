import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SliverBalanceCardWidget extends StatefulWidget {
  const SliverBalanceCardWidget({super.key});

  @override
  State<SliverBalanceCardWidget> createState() => _SliverBalanceCardWidgetState();
}

class _SliverBalanceCardWidgetState extends State<SliverBalanceCardWidget> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.a20,
      padding: AppPad.a24,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C5CE7), // Purple
            Color(0xFF5F4FD1),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withAlpha(77),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          AppGap.h10,

          // Balance Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isBalanceVisible
                    ? '\$53,500'
                    : '••••••', // TODO: Bind với data thật
                style: AppTextStyle.s28in.copyWith(
                  color: AppColors.white,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
              ),
            ],
          ),

          AppGap.h10,

          // Subtitle
          Text(
            'See the 6 jars structure >', // TODO: Thay bằng text phù hợp hoặc localization
            style: AppTextStyle.s12in.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),

          AppGap.h24,

          // Income & Expense Cards
          Row(
            children: [
              // Income Card
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.arrow_downward,
                  iconColor: const Color(0xFF00D09E),
                  label: 'INCOME',
                  amount: '\$5,000',
                  backgroundColor: Colors.white.withAlpha(38),
                  progressValue: 1.0, // TODO: Tính toán từ data
                ),
              ),

              AppGap.w12,

              // Expense Card
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.arrow_upward,
                  iconColor: const Color(0xFFFF6B93),
                  label: 'EXPENSE',
                  amount: '\$1,250',
                  backgroundColor: Colors.white.withAlpha(38),
                  progressValue: 0.25, // TODO: Tính toán từ data
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Mini Stat Card Component
class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String amount;
  final Color backgroundColor;
  final double progressValue;

  const _MiniStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
    required this.backgroundColor,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              AppGap.w4,
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppGap.h8,

          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGap.h8,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
