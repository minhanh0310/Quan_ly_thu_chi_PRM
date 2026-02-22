import 'package:Quan_ly_thu_chi_PRM/core/constants/resources.dart';
import 'package:Quan_ly_thu_chi_PRM/core/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/model/bottom_nav_item.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/widgets/custom_bottom_nav_bar.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/screen/home_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/screen/ledger_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/screen/plans_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/screen/stats_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final List<BottomNavItem> _navItems = [
  BottomNavItem(
    screen: const HomeScreen(),
    route: AppRoutes.home,
    label: 'Home',
    iconPath: IconPath.home,
  ),
  BottomNavItem(
    screen: const LedgerScreen(),
    route: AppRoutes.ledger,
    label: 'Ledger',
    iconPath: IconPath.ledger,
  ),
  BottomNavItem(
    screen: const PlansScreen(),
    route: AppRoutes.plans,
    label: 'Plans',
    iconPath: IconPath.plans,
  ),
  BottomNavItem(
    screen: const StatsScreen(),
    route: AppRoutes.stats,
    label: 'Stats',
    iconPath: IconPath.stats,
  ),
];

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    print('====> Navigated to: ${_navItems[index].route}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white, // TODO: Thay bằng theme color
        
        // IndexedStack giữ state của tất cả các tab
        body: IndexedStack(
          index: _selectedIndex,
          children: _navItems.map((item) => item.screen).toList(),
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _navItems,
        ),
      ),
    );
  }
}
