import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/savings_goal_model.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverActivePlansWidget extends StatelessWidget {
  const SliverActivePlansWidget({super.key});

  static const List<Color> planColors = [
    Color(0xFF6C5CE7), // Purple
    Color(0xFFFF6B93), // Pink
    Color(0xFF00D09E), // Green
    Color(0xFFFFC94D), // Yellow
    Color(0xFF5B4EFF), // Blue
    Color(0xFFFF6B6B), // Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFBE0B), // Orange
  ];

  static Color getColorByIndex(int index) {
    return planColors[index % planColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final service = FinanceDatabaseService();
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: AppPad.h20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'home_screen.active_plans'.tr(),
                  style: AppTextStyle.s12in.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.primaryTextColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all plans
                    print('====> View All Plans');
                  },
                  child: Text(
                    'common.view_all'.tr(),
                    style: AppTextStyle.s12in.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppGap.h12,

          // Plans List
          SizedBox(
            height: 200,
            child: StreamBuilder<List<SavingsGoalModel>>(
              stream: uid == null ? Stream.empty() : service.watchSavingsGoals(uid),
              builder: (context, snapshot) {
                final plans = snapshot.data ?? const [];
                final activePlans =
                    plans.where((p) => p.status == SavingsGoalStatus.active).toList();
                if (activePlans.isEmpty) {
                  return Center(
                    child: Text(
                      'home_screen.no_plans'.tr(),
                      style: AppTextStyle.s12in.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: AppPad.h20,
                  itemCount: activePlans.length,
                  separatorBuilder: (context, index) => AppGap.w16,
                  itemBuilder: (context, index) {
                    final plan = activePlans[index];
                    final color = getColorByIndex(index);
                    return _PlanCard(
                      title: plan.name,
                      current: context.read<CurrencyProvider>().formatCurrency(
                            plan.currentAmount,
                          ),
                      target: context.read<CurrencyProvider>().formatCurrency(
                            plan.targetAmount,
                          ),
                      progress: plan.progressPercent,
                      imageUrl: plan.imageUrl ?? Images.house,
                      color: color,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String current;
  final String target;
  final double progress;
  final String imageUrl;
  final Color color;

  const _PlanCard({
    required this.title,
    required this.current,
    required this.target,
    required this.progress,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPad.b10,
      padding: AppPad.a12,
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: AppBorderRadius.a16,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: AppBorderRadius.a12,
            child: Container(
              width: 68,
              height: 68,
              color: Colors.grey[200],
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image, color: AppColors.grey, size: 32);
                },
              ),
            ),
          ),

          AppGap.w16,

          // Plan Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyle.s14in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppGap.h4,
                Text(
                  '$current / $target',
                  style: AppTextStyle.s12in.copyWith(
                    fontSize: 11,
                    color: context.secondaryTextColor,
                  ),
                ),
                AppGap.h8,
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: AppBorderRadius.a4,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    AppGap.w8,
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTextStyle.s12in.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
