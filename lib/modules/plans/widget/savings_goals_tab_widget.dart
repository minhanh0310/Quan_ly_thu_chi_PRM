import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/savings_goal_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/screen/plan_detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class SavingsGoalsTabWidget extends StatefulWidget {
  const SavingsGoalsTabWidget({super.key});

  @override
  State<SavingsGoalsTabWidget> createState() => _SavingsGoalsTabWidgetState();
}

class _SavingsGoalsTabWidgetState extends State<SavingsGoalsTabWidget> {
  late List<SavingsGoalModel> _goals;
  late double _financialFreedomBalance;

  @override
  void initState() {
    super.initState();
    _goals = List<SavingsGoalModel>.from(SavingsGoalModel.mockList);
    JarModel? ffJar;
    for (final j in JarModel.mockList) {
      if (j.name == 'Financial Freedom') {
        ffJar = j;
        break;
      }
    }
    // Use jar amount as available balance (same unit as goals; mock in VND)
    _financialFreedomBalance = (ffJar?.amount ?? 45000) * 1000; // e.g. 45M VND
  }

  void _addPlan({
    required String name,
    required DateTime deadline,
    required double targetAmount,
  }) {
    if (name.trim().isEmpty) return;
    final id = '${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      _goals.insert(
        0,
        SavingsGoalModel(
          id: id,
          name: name.trim(),
          targetAmount: targetAmount,
          currentAmount: 0,
          deadline: deadline,
          color: AppColors.primaryPurple,
          icon: Icons.flag_rounded,
          createdAt: DateTime.now(),
          jarId: SavingsGoalModel.jarFinancialFreedom,
        ),
      );
    });
  }

  void _allocateToGoal(SavingsGoalModel goal, double amount) {
    if (amount <= 0 || amount > _financialFreedomBalance) return;
    final now = DateTime.now();
    final entry = AccumulationEntry(
      date: now,
      title: 'plans_screen.savings_month'.tr(namedArgs: {
        'month': '${now.month}',
        'year': '${now.year}',
      }),
      subtitle: 'plans_screen.from_salary_account'.tr(),
      amount: amount,
    );
    setState(() {
      _financialFreedomBalance -= amount;
      final idx = _goals.indexWhere((g) => g.id == goal.id);
      if (idx >= 0) {
        _goals[idx] = goal.copyWith(
          currentAmount: goal.currentAmount + amount,
          accumulationHistory: [...goal.accumulationHistory, entry],
        );
      }
    });
  }

  void _openPlanDetail(BuildContext context, SavingsGoalModel goal) {
    final goalNotifier = ValueNotifier<SavingsGoalModel>(goal);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PlanDetailScreen(
          goalNotifier: goalNotifier,
          financialFreedomBalance: _financialFreedomBalance,
          onAllocate: (amount) {
            _allocateToGoal(goalNotifier.value, amount);
            final updated =
                _goals.firstWhere((g) => g.id == goalNotifier.value.id);
            goalNotifier.value = updated;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeGoals =
        _goals.where((g) => g.status == SavingsGoalStatus.active).toList();
    final completedGoals =
        _goals.where((g) => g.status == SavingsGoalStatus.completed).toList();
    final overdueGoals =
        _goals.where((g) => g.status == SavingsGoalStatus.overdue).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: AppGap.h16),

        // Header: Financial Journey + subtitle + Add (+) button
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPad.h20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'plans_screen.financial_journey'.tr(),
                        style: AppTextStyle.s20in.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppGap.h4,
                      Text(
                        'plans_screen.long_term_goals_tracking'.tr(),
                        style: AppTextStyle.s14in.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AppColors.primaryPurple,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: _showAddPlanDialog,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: AppGap.h24),

        // Active goals — card style (reference design)
        if (activeGoals.isNotEmpty)
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = activeGoals[index];
                  return Padding(
                    padding: AppPad.b16,
                    child: _FinancialJourneyCard(
                      goal: goal,
                      onTap: () => _openPlanDetail(context, goal),
                      onUpdateProgress: () =>
                          _showAllocateDialog(context, goal),
                    ),
                  );
                },
                childCount: activeGoals.length,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: _EmptyStateCard(
                icon: Icons.savings_outlined,
                message: 'plans_screen.no_goals'.tr(),
              ),
            ),
          ),

        // Overdue
        if (overdueGoals.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: Text(
                'Overdue Goals',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.expenseRed,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = overdueGoals[index];
                  return Padding(
                    padding: AppPad.b16,
                    child: _FinancialJourneyCard(
                      goal: goal,
                      onTap: () => _openPlanDetail(context, goal),
                      onUpdateProgress: () =>
                          _showAllocateDialog(context, goal),
                    ),
                  );
                },
                childCount: overdueGoals.length,
              ),
            ),
          ),
        ],

        // Completed
        if (completedGoals.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPad.h20,
              child: Text(
                'Completed Goals',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.incomeGreen,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: AppPad.h20,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final goal = completedGoals[index];
                  return Padding(
                    padding: AppPad.b16,
                    child: _FinancialJourneyCard(
                      goal: goal,
                      onTap: () => _openPlanDetail(context, goal),
                      onUpdateProgress: null,
                    ),
                  );
                },
                childCount: completedGoals.length,
              ),
            ),
          ),
        ],

        SliverToBoxAdapter(child: AppGap.h100),
      ],
    );
  }

  void _showAddPlanDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 365));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                  'plans_screen.add_plan'.tr(),
                  style: AppTextStyle.s20in.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppGap.h20,
                // Plan name
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'plans_screen.plan_name'.tr(),
                    hintText: 'plans_screen.plan_name_hint'.tr(),
                    prefixIcon: const Icon(Icons.flag_rounded),
                    border: OutlineInputBorder(
                      borderRadius: AppBorderRadius.a12,
                    ),
                  ),
                ),
                AppGap.h16,
                // Target amount
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'plans_screen.target_amount'.tr(),
                    hintText: '10000000',
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                    prefixText: 'VND ',
                    border: OutlineInputBorder(
                      borderRadius: AppBorderRadius.a12,
                    ),
                  ),
                ),
                AppGap.h16,
                // End date
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                    );
                    if (date != null) {
                      setModalState(() => selectedDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'plans_screen.end_date'.tr(),
                      prefixIcon: const Icon(Icons.calendar_today_rounded),
                      border: OutlineInputBorder(
                        borderRadius: AppBorderRadius.a12,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: AppTextStyle.s16in.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                AppGap.h24,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
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
                          final name = nameController.text.trim();
                          final amountText = amountController.text.replaceAll(',', '');
                          final amount = double.tryParse(amountText) ?? 0;
                          if (name.isNotEmpty && amount > 0) {
                            Navigator.pop(context);
                            _addPlan(
                              name: name,
                              deadline: selectedDate,
                              targetAmount: amount,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
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
      ),
    );
  }

  void _showAllocateDialog(BuildContext context, SavingsGoalModel goal) {
    final controller = TextEditingController();
    final ffBalance = _financialFreedomBalance;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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
                style: AppTextStyle.s18in.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppGap.h8,
              Text(
                '${'plans_screen.available_from_financial_freedom'.tr()}: ${_formatCurrency(ffBalance)}',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppGap.h8,
              Text(
                'Target: ${_formatCurrency(goal.targetAmount)} · Current: ${_formatCurrency(goal.currentAmount)}',
                style: AppTextStyle.s14in.copyWith(
                  color: AppColors.textSecondary,
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
                  prefixText: 'VND ',
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a12,
                  ),
                ),
              ),
              AppGap.h20,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
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
                        if (amount > 0 && amount <= ffBalance) {
                          _allocateToGoal(goal, amount);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
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

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VND';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VND';
    }
    return '${amount.toStringAsFixed(0)} VND';
  }
}

class _FinancialJourneyCard extends StatelessWidget {
  final SavingsGoalModel goal;
  final VoidCallback? onTap;
  final VoidCallback? onUpdateProgress;

  const _FinancialJourneyCard({
    required this.goal,
    this.onTap,
    this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (goal.progressPercent * 100).toInt();
    final milestones = goal.milestones ?? [];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorderRadius.a20,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorderRadius.a20,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Image / placeholder area
          Container(
            height: 120,
            width: double.infinity,
            color: goal.color.withValues(alpha: 0.15),
            child: goal.imageUrl != null
                ? Image.network(goal.imageUrl!, fit: BoxFit.cover)
                : Center(
                    child: Icon(
                      goal.icon,
                      size: 48,
                      color: goal.color.withValues(alpha: 0.6),
                    ),
                  ),
          ),
          Padding(
            padding: AppPad.a16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.name,
                        style: AppTextStyle.s18in.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: AppPad.h8v4,
                      decoration: BoxDecoration(
                        color: goal.color.withValues(alpha: 0.12),
                        borderRadius: AppBorderRadius.a8,
                      ),
                      child: Text(
                        'TARGET: ${goal.deadline.year}',
                        style: AppTextStyle.s12in.copyWith(
                          color: goal.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                AppGap.h4,
                Text(
                  'Goal: ${_formatCurrency(goal.targetAmount)}',
                  style: AppTextStyle.s14in.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppGap.h16,
                // Progress
                Text(
                  'plans_screen.progress'.tr().toUpperCase(),
                  style: AppTextStyle.s12in.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppGap.h4,
                Row(
                  children: [
                    Text(
                      '$progressPercent%',
                      style: AppTextStyle.s24in.copyWith(
                        fontWeight: FontWeight.bold,
                        color: goal.color,
                      ),
                    ),
                    AppGap.w12,
                    Expanded(
                      child: ClipRRect(
                        borderRadius: AppBorderRadius.a4,
                        child: LinearProgressIndicator(
                          value: goal.progressPercent,
                          backgroundColor: AppColors.lightGrayBackground,
                          valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                // Roadmap
                if (milestones.isNotEmpty) ...[
                  AppGap.h16,
                  Row(
                    children: [
                      Icon(
                        Icons.map_rounded,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      AppGap.w4,
                      Text(
                        'plans_screen.roadmap'.tr(),
                        style: AppTextStyle.s12in.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
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
                            size: 18,
                            color: m.isReached
                                ? goal.color
                                : AppColors.textTertiary,
                          ),
                          AppGap.w8,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m.title,
                                  style: AppTextStyle.s12in.copyWith(
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
                if (onUpdateProgress != null && !goal.isCompleted) ...[
                  AppGap.h16,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goal.color,
                        foregroundColor: AppColors.white,
                        padding: AppPad.v14,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.a12,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('plans_screen.update_progress'.tr()),
                          AppGap.w4,
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VND';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VND';
    }
    return '${amount.toStringAsFixed(0)} VND';
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyStateCard({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.a32,
      decoration: BoxDecoration(
        color: AppColors.lightGrayBackground,
        borderRadius: AppBorderRadius.a16,
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.grey.withValues(alpha: 0.5),
          ),
          AppGap.h12,
          Text(
            message,
            style: AppTextStyle.s14in.copyWith(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
