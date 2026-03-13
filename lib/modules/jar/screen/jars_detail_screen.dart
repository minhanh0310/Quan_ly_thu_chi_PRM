import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_balance_card_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_list_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_history_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_info_footer_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class JarsDetailScreen extends StatelessWidget {
  final double? totalBalance;

  const JarsDetailScreen({super.key, this.totalBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(
          'jars_screen.title'.tr(),
          style: AppTextStyle.s16in.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _Body(totalBalance: totalBalance),
    );
  }
}

class _Body extends StatelessWidget {
  final double? totalBalance;
  const _Body({required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    final service = FinanceDatabaseService();
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: AppPad.h16v24,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, authSnapshot) {
                  final uid = authSnapshot.data?.uid;
                  if (uid == null) {
                    return SliverJarsBalanceCardWidget(
                      totalBalance: totalBalance ?? 0,
                    );
                  }
                  return StreamBuilder<List<JarModel>>(
                    stream: service.watchJars(uid),
                    builder: (context, snapshot) {
                      final jars = snapshot.data ?? const [];
                      final total = jars.fold<double>(
                        0,
                        (sum, j) => sum + j.amount,
                      );
                      return SliverJarsBalanceCardWidget(
                        totalBalance: totalBalance ?? total,
                      );
                    },
                  );
                },
              ),

              AppGap.h24,

              SliverJarsListWidget(),

              AppGap.h32,

              const SliverJarsHistoryWidget(),

              AppGap.h24,

              const SliverJarsInfoFooterWidget(),
              
              AppGap.h32,
            ]),
          ),
        ),
      ],
    );
  }
}
