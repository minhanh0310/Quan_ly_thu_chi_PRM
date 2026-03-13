import 'package:easy_localization/easy_localization.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/core/widgets/template/function_screen_template.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/model/stats_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/widget/budget_comparison_bar_chart.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/widget/expense_pie_chart.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/widget/budget_status_summary.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/widget/budget_warning_dialog.dart';

class StatsScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const StatsScreen({super.key, this.onOpenDrawer});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      backgroundColor: context.backgroundColor,
      onOpenDrawer: widget.onOpenDrawer,
      screen: _Body(tabController: _tabController),
    );
  }
}

class _Body extends StatelessWidget {
  final TabController tabController;

  const _Body({required this.tabController});

  @override
  Widget build(BuildContext context) {
    // Using mock data - replace with Provider/BLoC
    final statsData = StatsData.mockData;

    return Column(
      children: [
        AppGap.h20,

        // Header
        Padding(
          padding: AppPad.h20,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'stats_screen.title'.tr(),
                      style: AppTextStyle.s24.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppGap.h4,
                    Text(
                      'stats_screen.subtitle'.tr(),
                      style: AppTextStyle.s14in.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        AppGap.h16,

        // Tab bar
        Container(
          margin: AppPad.h20,
          decoration: BoxDecoration(
            color: context.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: tabController,
            labelColor: context.onPrimaryColor,
            unselectedLabelColor: context.secondaryTextColor,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: AppTextStyle.s14.copyWith(fontWeight: FontWeight.w600),
            unselectedLabelStyle: AppTextStyle.s14.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'stats_screen.overview'.tr()),
              Tab(text: 'stats_screen.categories'.tr()),
            ],
          ),
        ),

        AppGap.h16,

        // Tab content
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _OverviewTab(data: statsData),
              _CategoriesTab(data: statsData),
            ],
          ),
        ),
      ],
    );
  }
}

/// Overview Tab - Bar Chart and Budget Status
class _OverviewTab extends StatelessWidget {
  final StatsData data;

  const _OverviewTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPad.h20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget Status Summary
          BudgetStatusSummary(
            budget: data.totalBudget,
            expense: data.totalExpense,
            currentMonth: data.currentMonth,
          ),

          AppGap.h24,

          // Bar Chart Section
          _buildSectionTitle('stats_screen.budget_vs_actual'.tr(), context),
          AppGap.h12,
          Container(
            padding: AppPad.h16,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                BudgetComparisonBarChart(data: data.monthlyData),
                AppGap.h12,
                const BarChartLegend(),
              ],
            ),
          ),

          AppGap.h24,

          // Warning Banner (if applicable)
          BudgetWarningBanner(percentage: data.percentageUsed),

          AppGap.h20,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.s20.copyWith(
        color: context.primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Categories Tab - Pie Chart and Breakdown
class _CategoriesTab extends StatelessWidget {
  final StatsData data;

  const _CategoriesTab({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPad.h20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie Chart Section
          _buildSectionTitle('stats_screen.expense_by_category'.tr(), context),
          AppGap.h12,
          Container(
            padding: AppPad.h16,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ExpensePieChart(data: data.categoryExpenses),
          ),

          AppGap.h24,

          // Category Breakdown List
          _buildSectionTitle('stats_screen.category_breakdown'.tr(), context),
          AppGap.h12,
          Container(
            padding: AppPad.h16,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CategoryBreakdownList(data: data.categoryExpenses),
          ),

          AppGap.h20,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.s20.copyWith(
        color: context.primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// Helper function to check and show budget warning
/// Call this function when adding a new expense
Future<bool> checkAndShowBudgetWarning({
  required BuildContext context,
  required double currentExpense,
  required double budget,
  required double newExpenseAmount,
}) async {
  // Check if this expense would exceed budget
  final willExceed = BudgetWarningDialog.willExceedBudget(
    currentExpense: currentExpense,
    budget: budget,
    newExpenseAmount: newExpenseAmount,
  );

  if (willExceed) {
    // Show warning dialog
    final userConfirmed = await BudgetWarningDialog.show(
      context: context,
      currentExpense: currentExpense,
      budget: budget,
      newExpenseAmount: newExpenseAmount,
    );
    return userConfirmed;
  }

  // No warning needed, proceed
  return true;
}
