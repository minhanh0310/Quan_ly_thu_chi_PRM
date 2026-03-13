import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_list_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverJarsHistoryWidget extends StatelessWidget {
  const SliverJarsHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'jars_screen.distribution_history'.tr(),
          trailing: Icon(
            Icons.history_rounded,
            size: 20,
            color: context.primaryTextColor,
          ),
        ),
        AppGap.h16,

        ...DistributionEntry.mockList.map(
          (entry) => _HistoryCard(entry: entry),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final DistributionEntry entry;

  const _HistoryCard({required this.entry});

  String _formatAmount(BuildContext context, double v) =>
      context.read<CurrencyProvider>().formatCurrency(v);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.b10,
      padding: AppPad.h16v12,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: AppBorderRadius.a12,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // icon
          Container(
            decoration: BoxDecoration(
              color: context.surfaceVariant,
              borderRadius: AppBorderRadius.a10,
            ),
            child: Padding(
              padding: AppPad.a8,
              child: const Icon(
                Icons.trending_up_rounded,
                color: AppColors.primaryPurple,
                size: 20,
              ),
            ),
          ),

          AppGap.w12,

          // subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.month,
                  style: AppTextStyle.s12in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                ),
                AppGap.h2,
                Text(
                  entry.subtitle,
                  style: AppTextStyle.s12in.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '+${_formatAmount(context, entry.amount)}',
            style: AppTextStyle.s14in.copyWith(
              color: AppColors.incomeGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
