import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_balance_card_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_quick_actions_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_active_plans_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/widget/sliver_recent_activity_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Balance Card
        SliverToBoxAdapter(child: SliverBalanceCardWidget()),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Quick Actions Section
        const SliverQuickActionsWidget(),

        // Gap
        const SliverToBoxAdapter(child: SizedBox(height: 30)),

        // Active Plans Section
        const SliverActivePlansWidget(),

        // Gap
        const SliverToBoxAdapter(child: SizedBox(height: 30)),

        // Recent Activity Section
        const SliverRecentActivityWidget(),

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
