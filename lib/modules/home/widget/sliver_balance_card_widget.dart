import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/screen/jars_detail_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:Quan_ly_thu_chi_PRM/models/transaction_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverBalanceCardWidget extends StatefulWidget {
  const SliverBalanceCardWidget({super.key});

  @override
  State<SliverBalanceCardWidget> createState() =>
      _SliverBalanceCardWidgetState();
}

class _SliverBalanceCardWidgetState extends State<SliverBalanceCardWidget> {
  bool _isBalanceVisible = true;

  void _openJarsDetail(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const JarsDetailScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild when locale changes
    final _ = context.locale;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final service = FinanceDatabaseService();
    if (uid != null) {
      service.ensureDefaultJars(uid);
    }
    return Container(
      margin: AppPad.a20,
      padding: AppPad.a24,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPurple, AppColors.primaryPurpleDark],
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
          Text(
            'home_screen.total_balance'.tr(),
            style: AppTextStyle.s14in.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          AppGap.h10,

          // Balance Amount + visibility toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<List<JarModel>>(
                stream: uid == null ? Stream.empty() : service.watchJars(uid),
                builder: (context, snapshot) {
                  final jars = snapshot.data ?? const [];
                  final total = jars.fold<double>(
                    0,
                    (sum, j) => sum + j.amount,
                  );
                  return Text(
                    _isBalanceVisible
                        ? context.read<CurrencyProvider>().formatCurrency(total)
                        : '••••••',
                    style: AppTextStyle.s28in.copyWith(
                      color: AppColors.white,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.white.withValues(alpha: 0.7),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _isBalanceVisible = !_isBalanceVisible),
              ),
            ],
          ),

          AppGap.h10,

          GestureDetector(
            onTap: () => _openJarsDetail(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'home_screen.view_jars'.tr(),
                  style: AppTextStyle.s12in.copyWith(
                    color: AppColors.lightGray,
                  ),
                ),
                AppGap.w4,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.white.withValues(alpha: 0.7),
                  size: 11,
                ),
              ],
            ),
          ),

          AppGap.h24,

          // ── Income & Expense Mini Cards ──
          Row(
            children: [
              Expanded(
                child: StreamBuilder<List<TransactionModel>>(
                  stream: uid == null
                      ? Stream.empty()
                      : service.watchTransactions(uid),
                  builder: (context, snapshot) {
                    final tx = snapshot.data ?? const [];
                    final now = DateTime.now();
                    final monthKey =
                        '${now.year}-${now.month.toString().padLeft(2, '0')}';
                    final monthTx = tx.where((t) {
                      final key =
                          '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
                      return key == monthKey;
                    }).toList();
                    final income = monthTx
                        .where((t) => t.isIncome)
                        .fold<double>(0, (sum, t) => sum + t.amount);
                    final expense = monthTx
                        .where((t) => !t.isIncome)
                        .fold<double>(0, (sum, t) => sum + t.amount);
                    final total = income + expense;
                    final incomePct = total > 0
                        ? (income / total).toDouble()
                        : 0.0;
                    return _MiniStatCard(
                      icon: IconPath.arrowUpRight,
                      iconColor: const Color(0xFF00D09E),
                      label: 'home_screen.income'.tr(),
                      amount: context.read<CurrencyProvider>().formatCurrency(
                        income,
                      ),
                      backgroundColor: AppColors.white.withAlpha(38),
                      progressValue: incomePct,
                    );
                  },
                ),
              ),
              AppGap.w12,
              Expanded(
                child: StreamBuilder<List<TransactionModel>>(
                  stream: uid == null
                      ? Stream.empty()
                      : service.watchTransactions(uid),
                  builder: (context, snapshot) {
                    final tx = snapshot.data ?? const [];
                    final now = DateTime.now();
                    final monthKey =
                        '${now.year}-${now.month.toString().padLeft(2, '0')}';
                    final monthTx = tx.where((t) {
                      final key =
                          '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
                      return key == monthKey;
                    }).toList();
                    final income = monthTx
                        .where((t) => t.isIncome)
                        .fold<double>(0, (sum, t) => sum + t.amount);
                    final expense = monthTx
                        .where((t) => !t.isIncome)
                        .fold<double>(0, (sum, t) => sum + t.amount);
                    final total = income + expense;
                    final expensePct = total > 0
                        ? (expense / total).toDouble()
                        : 0.0;
                    return _MiniStatCard(
                      icon: IconPath.arrowDownLeft,
                      iconColor: const Color(0xFFFF6B93),
                      label: 'home_screen.expense'.tr(),
                      amount: context.read<CurrencyProvider>().formatCurrency(
                        expense,
                      ),
                      backgroundColor: AppColors.white.withAlpha(38),
                      progressValue: expensePct,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String icon;
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
              SvgPicture.asset(
                icon,
                width: 10,
                height: 10,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              AppGap.w10,
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
