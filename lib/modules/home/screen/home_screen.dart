import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_balance_card_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_quick_actions_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_active_plans_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_recent_activity_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(appBar: CustomAppBar(currentTabIndex: 0), body: _Body()),
    );
  }
}

class _Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SliverBalanceCardWidget()),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        SliverQuickActionsWidget(),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),

        SliverActivePlansWidget(),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),

        SliverRecentActivityWidget(),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
