import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverJarsBalanceCardWidget extends StatelessWidget {
  final double totalBalance;

  const SliverJarsBalanceCardWidget({super.key, required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    final formattedBalance = context.read<CurrencyProvider>().formatCurrency(
      totalBalance,
    );
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
          Row(
            children: [
              _Badge(
                label: 'jars_screen.cash_in'.tr(),
                value: '+12.5%', //TODO: lay gia tri thuc te
                icon: Icons.trending_up_rounded,
                color: AppColors.incomeGreen,
              ),
              AppGap.w20,
              _Badge(
                label: 'jars_screen.cash_out'.tr(),
                value: '-4.2%',
                icon: Icons.trending_down_rounded,
                color: AppColors.expenseRed,
              ),
            ],
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
