import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SliverBalanceCardWidget extends StatefulWidget {
  const SliverBalanceCardWidget({super.key});

  @override
  State<SliverBalanceCardWidget> createState() =>
      _SliverBalanceCardWidgetState();
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
            AppColors.primaryPurple,
            AppColors.primaryPurpleDark,
          ],
        ),
        borderRadius: AppBorderRadius.a28,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withAlpha(77),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Total Balance',
            style: AppTextStyle.s14in.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          AppGap.h10,

          // Balance Amount với visibility toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isBalanceVisible ? '\$53,500' : '••••••',
                // TODO: Bind với data từ BLoC/Provider
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
                  color: AppColors.white.withValues(alpha: 0.7),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _isBalanceVisible = !_isBalanceVisible);
                },
              ),
            ],
          ),

          AppGap.h10,

          // Subtitle link
          Text(
            'See the 6 jars structure >',
            // TODO: Thay bằng localization
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),

          AppGap.h24,

          // Income & Expense Mini Cards
          Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.arrow_downward,
                  iconColor: const Color(0xFF00D09E),
                  label: 'INCOME',
                  amount: '\$5,000',
                  // TODO: Bind data
                  backgroundColor: AppColors.white.withAlpha(38),
                  progressValue: 1.0,
                  // TODO: Calculate from data
                ),
              ),
              AppGap.w12,
              Expanded(
                child: _MiniStatCard(
                  icon: Icons.arrow_upward,
                  iconColor: const Color(0xFFFF6B93),
                  label: 'EXPENSE',
                  amount: '\$1,250',
                  // TODO: Bind data
                  backgroundColor: AppColors.white.withAlpha(38),
                  progressValue: 0.25,
                  // TODO: Calculate from data
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mini Stat Card
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
        borderRadius: AppBorderRadius.a16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Label
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              AppGap.w4,
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyle.s12in.copyWith(
                    fontSize: 10,
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          AppGap.h8,

          // Amount
          Text(
            amount,
            style: AppTextStyle.s16in.copyWith(
              fontSize: 18,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          AppGap.h8,

          // Progress bar
          ClipRRect(
            borderRadius: AppBorderRadius.a4,
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: AppColors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
