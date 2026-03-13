import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/savings_goal_model.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class PlanDetailScreen extends StatelessWidget {
  final ValueNotifier<SavingsGoalModel> goalNotifier;
  final double financialFreedomBalance;
  final void Function(double amount) onAllocate;

  const PlanDetailScreen({
    super.key,
    required this.goalNotifier,
    required this.financialFreedomBalance,
    required this.onAllocate,
  });

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  String _formatCurrency(BuildContext context, double amount) {
    return context.read<CurrencyProvider>().formatCurrency(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: ValueListenableBuilder<SavingsGoalModel>(
        valueListenable: goalNotifier,
        builder: (context, goal, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, goal),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppPad.h20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: AppTextStyle.s24in.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppGap.h20,
                      _buildProgressCard(context, goal),
                      AppGap.h16,
                      if (!goal.isCompleted) _buildSmartForecast(context, goal),
                      AppGap.h16,
                      _buildJourneySection(goal),
                      AppGap.h24,
                      _buildAccumulationHistory(context, goal),
                      AppGap.h100,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<SavingsGoalModel>(
        valueListenable: goalNotifier,
        builder: (context, goal, _) {
          if (goal.isCompleted) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: AppPad.a20,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showAllocateSheet(context, goal),
                      icon: const Icon(Icons.add_rounded, size: 22),
                      label: Text('plans_screen.accumulate_now'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goal.color,
                        foregroundColor: AppColors.white,
                        padding: AppPad.v16,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.a12,
                        ),
                      ),
                    ),
                  ),
                  AppGap.w12,
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline_rounded, size: 22),
                    style: IconButton.styleFrom(
                      backgroundColor: goal.color.withValues(alpha: 0.2),
                      foregroundColor: goal.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SavingsGoalModel goal) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            goal.imageUrl != null
                ? Image.network(goal.imageUrl!, fit: BoxFit.cover)
                : Container(
                    color: goal.color.withValues(alpha: 0.2),
                    child: Center(
                      child: Icon(
                        goal.icon,
                        size: 64,
                        color: goal.color.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Row(
                children: [
                  Container(
                    padding: AppPad.h8v4,
                    decoration: BoxDecoration(
                      color: goal.color,
                      borderRadius: AppBorderRadius.a8,
                    ),
                    child: Text(
                      'plans_screen.active_plan'.tr().toUpperCase(),
                      style: AppTextStyle.s12in.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AppGap.w12,
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AppColors.white,
                  ),
                  AppGap.w4,
                  Text(
                    '${'plans_screen.end_date'.tr()}: ${_formatDate(goal.deadline)}',
                    style: AppTextStyle.s12in.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, SavingsGoalModel goal) {
    final percent = (goal.progressPercent * 100).toInt();
    return Container(
      padding: AppPad.a20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderRadius.a16,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'plans_screen.current_progress'.tr(),
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppGap.h8,
          Row(
            children: [
              Text(
                '$percent%',
                style: AppTextStyle.s28in.copyWith(
                  fontWeight: FontWeight.bold,
                  color: goal.color,
                ),
              ),
              AppGap.w16,
              Expanded(
                child: ClipRRect(
                  borderRadius: AppBorderRadius.a4,
                  child: LinearProgressIndicator(
                    value: goal.progressPercent,
                    backgroundColor: AppColors.lightGrayBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                    minHeight: 10,
                  ),
                ),
              ),
            ],
          ),
          AppGap.h16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'plans_screen.accumulated'.tr().toUpperCase(),
                    style: AppTextStyle.s10in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(context, goal.currentAmount),
                    style: AppTextStyle.s16in.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.incomeGreen,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'plans_screen.remaining'.tr().toUpperCase(),
                    style: AppTextStyle.s10in.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    _formatCurrency(context, goal.remainingAmount),
                    style: AppTextStyle.s16in.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.expenseRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartForecast(BuildContext context, SavingsGoalModel goal) {
    final monthly = goal.monthlyRequired;
    final monthsLeft = goal.deadline.difference(DateTime.now()).inDays / 30;
    String forecast = '';
    if (monthsLeft > 0 && monthly > 0) {
      final estimatedMonth = DateTime.now().add(
        Duration(days: (goal.remainingAmount / monthly * 30).round()),
      );
      forecast =
          'Với tốc độ tiết kiệm ${_formatCurrency(context, monthly)}/tháng, bạn sẽ hoàn thành mục tiêu này vào tháng ${estimatedMonth.month}/${estimatedMonth.year}.';
    }
    if (forecast.isEmpty) forecast = 'Thêm tiền tích lũy để xem dự báo.';
    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: goal.color.withValues(alpha: 0.08),
        borderRadius: AppBorderRadius.a12,
        border: Border.all(color: goal.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.trending_up_rounded, color: goal.color, size: 24),
          AppGap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'plans_screen.smart_forecast'.tr(),
                  style: AppTextStyle.s12in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: goal.color,
                  ),
                ),
                AppGap.h4,
                Text(
                  forecast,
                  style: AppTextStyle.s12in.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySection(SavingsGoalModel goal) {
    final milestones = goal.milestones ?? [];
    if (milestones.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'plans_screen.roadmap'.tr(),
              style: AppTextStyle.s14in.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('plans_screen.add_milestone'.tr()),
            ),
          ],
        ),
        AppGap.h8,
        ...milestones.map(
          (m) => Padding(
            padding: AppPad.b8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  m.isReached
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: m.isReached ? goal.color : AppColors.textTertiary,
                ),
                AppGap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: AppTextStyle.s14in.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        m.description,
                        style: AppTextStyle.s12in.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (m.date != null)
                        Text(
                          _formatDate(m.date!),
                          style: AppTextStyle.s10in.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccumulationHistory(
    BuildContext context,
    SavingsGoalModel goal,
  ) {
    final history = goal.accumulationHistory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'plans_screen.accumulation_history'.tr(),
              style: AppTextStyle.s16in.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            AppGap.w8,
            Icon(
              Icons.history_rounded,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
        AppGap.h12,
        if (history.isEmpty)
          Container(
            padding: AppPad.a20,
            decoration: BoxDecoration(
              color: AppColors.lightGrayBackground,
              borderRadius: AppBorderRadius.a12,
            ),
            child: Center(
              child: Text(
                'Chưa có lịch sử tích lũy',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppBorderRadius.a16,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: AppColors.grey.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final entry = history[index];
                return Padding(
                  padding: AppPad.a16,
                  child: Row(
                    children: [
                      Container(
                        padding: AppPad.a10,
                        decoration: BoxDecoration(
                          color: AppColors.incomeGreen.withValues(alpha: 0.15),
                          borderRadius: AppBorderRadius.a10,
                        ),
                        child: Icon(
                          Icons.trending_up_rounded,
                          color: AppColors.incomeGreen,
                          size: 22,
                        ),
                      ),
                      AppGap.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              style: AppTextStyle.s14in.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              entry.subtitle,
                              style: AppTextStyle.s12in.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+${_formatCurrency(context, entry.amount)}',
                        style: AppTextStyle.s14in.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.incomeGreen,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showAllocateSheet(BuildContext context, SavingsGoalModel goal) {
    final controller = TextEditingController();
    final balance = financialFreedomBalance;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: AppPad.a20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppGap.h20,
              Text(
                '${'plans_screen.add_to_plan'.tr()} "${goal.name}"',
                style: AppTextStyle.s18in.copyWith(fontWeight: FontWeight.bold),
              ),
              AppGap.h8,
              Text(
                '${'plans_screen.available_from_financial_freedom'.tr()}: ${_formatCurrency(ctx, balance)}',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppGap.h20,
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'plans_screen.amount'.tr(),
                  hintText: '0',
                  prefixText: ctx.read<CurrencyProvider>().inputPrefix,
                  border: OutlineInputBorder(borderRadius: AppBorderRadius.a12),
                ),
              ),
              AppGap.h20,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: AppPad.v14,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.a12,
                        ),
                      ),
                      child: Text('common.cancel'.tr()),
                    ),
                  ),
                  AppGap.w12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final text = controller.text.replaceAll(',', '');
                        final amount = double.tryParse(text) ?? 0;
                        if (amount > 0 && amount <= balance) {
                          onAllocate(amount);
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goal.color,
                        foregroundColor: AppColors.white,
                        padding: AppPad.v14,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.a12,
                        ),
                      ),
                      child: Text('common.save'.tr()),
                    ),
                  ),
                ],
              ),
              AppGap.h20,
            ],
          ),
        ),
      ),
    );
  }
}
