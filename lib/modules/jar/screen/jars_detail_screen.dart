import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_balance_card_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_list_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_history_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jars_info_footer_widget.dart';

class JarsDetailScreen extends StatelessWidget {
  final double totalBalance;

  const JarsDetailScreen({super.key, this.totalBalance = 53500});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '6 Jars Structure',
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
  final double totalBalance;
  const _Body({required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: AppPad.h16v24,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SliverJarsBalanceCardWidget(totalBalance: totalBalance),

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
