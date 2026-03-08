import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'dart:ui';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/model/bottom_nav_item.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/widgets/custom_bottom_nav_bar.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/screen/home_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/screen/ledger_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/screen/plans_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/screen/stats_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/core/widgets/drawer_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    // print('====> Navigated to: ${_navItems[index].route}');
  }

  late final List<BottomNavItem> _navItems = [
    BottomNavItem(
      screen: HomeScreen(onOpenDrawer: _openDrawer),
      route: AppRoutes.home,
      label: 'home_screen.home'.tr(),
      iconPath: IconPath.home,
    ),
    BottomNavItem(
      screen: LedgerScreen(onOpenDrawer: _openDrawer),
      route: AppRoutes.ledger,
      label: 'ledger_screen.title'.tr(),
      iconPath: IconPath.ledger,
    ),
    BottomNavItem(
      screen: PlansScreen(onOpenDrawer: _openDrawer),
      route: AppRoutes.plans,
      label: 'plans_screen.title'.tr(),
      iconPath: IconPath.plans,
    ),
    BottomNavItem(
      screen: StatsScreen(onOpenDrawer: _openDrawer),
      route: AppRoutes.stats,
      label: 'stats_screen.title'.tr(),
      iconPath: IconPath.stats,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: context.backgroundColor,
        drawer: SafeArea(
          top: false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.zero,
              ),
              child: const DrawerWidget(),
            ),
          ),
        ),

        body: IndexedStack(
          index: _selectedIndex,
          children: _navItems.map((item) => item.screen).toList(),
        ),

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: _navItems,
        ),
      ),
    );
  }
}
