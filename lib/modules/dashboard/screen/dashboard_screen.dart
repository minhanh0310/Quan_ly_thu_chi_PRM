import 'dart:ui';
import 'package:Quan_ly_thu_chi_PRM/core/routers/routes.dart';
import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/model/bottom_nav_item.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/widgets/custom_bottom_nav_bar.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/screen/home_screen.dart';
// TODO: Import các screen còn lại
// import 'package:Quan_ly_thu_chi_PRM/modules/ledger/screen/ledger_screen.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/plans/screen/plans_screen.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/stats/screen/stats_screen.dart';

// TODO: Import IconPath constants
// import 'package:Quan_ly_thu_chi_PRM/core/constants/icon_path.dart';

// TODO: Import AppSideMenu nếu cần
// import 'package:Quan_ly_thu_chi_PRM/core/widgets/app_side_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final List<BottomNavItem> _navItems = [
  BottomNavItem(
    screen: const HomeScreen(),
    route: AppRoutes.home,
    label: 'Home',
    iconPath: 'assets/icons/home.svg', // TODO: Thay bằng IconPath.home
  ),
  BottomNavItem(
    screen: const Placeholder(), // TODO: Thay bằng LedgerScreen()
    route: AppRoutes.ledger, // TODO: Thay bằng LedgerScreen.routeName
    label: 'Ledger',
    iconPath: 'assets/icons/ledger.svg', // TODO: Thay bằng IconPath.ledger
  ),
  BottomNavItem(
    screen: const Placeholder(), // TODO: Thay bằng PlansScreen()
    route: AppRoutes.plans, // TODO: Thay bằng PlansScreen.routeName
    label: 'Plans',
    iconPath: 'assets/icons/plans.svg', // TODO: Thay bằng IconPath.plans
  ),
  BottomNavItem(
    screen: const Placeholder(), // TODO: Thay bằng StatsScreen()
    route: AppRoutes.stats, // TODO: Thay bằng StatsScreen.routeName
    label: 'Stats',
    iconPath: 'assets/icons/stats.svg', // TODO: Thay bằng IconPath.stats
  ),
];

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // TODO: Nếu cần animation cho tab cụ thể, uncomment và sửa index
    // if (index == 2) {
    //   _animationController.forward(from: 0);
    // }

    print('====> Navigated to: ${_navItems[index].route}');
  }

  AppBar? _buildAppBar(BuildContext context) {
    // TODO: Implement AppBar logic dựa vào _selectedIndex
    // VD: Home có drawer icon + notification + avatar
    //     Các tab khác có thể có back button hoặc title khác

    if (_selectedIndex == 0) {
      // Home AppBar
      return AppBar(
        backgroundColor: Colors.white, // TODO: Thay bằng theme color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'JarsFlow', // TODO: Thay bằng app name từ config
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'MODERN WEALTH',  
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white, size: 20),
              // TODO: Load user avatar
            ),
          ),
        ],
      );
    }

    // TODO: Implement AppBar cho các tab khác
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Nếu cần animation cho tab cụ thể, wrap với SlideTransition
    Widget currentScreen = _navItems[_selectedIndex].screen;

    // Example: Animation cho index 2 (Plans)
    // Widget currentScreen = _selectedIndex == 2
    //     ? SlideTransition(
    //         position: _slideAnimation,
    //         child: _navItems[_selectedIndex].screen,
    //       )
    //     : _navItems[_selectedIndex].screen;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor:
              Colors.white, // TODO: Thay bằng context.backgroundColor từ theme
          // TODO: Drawer chỉ hiện ở Home (index 0)
          drawer: _selectedIndex == 0
              ? SafeArea(
                  top: false,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Drawer(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                      ),
                      child: const Placeholder(),
                      // TODO: Thay bằng AppSideMenu(onNavigateToTab: _onItemTapped)
                    ),
                  ),
                )
              : null,

          appBar: _buildAppBar(context),

          // IndexedStack giữ state của tất cả các tab
          body: IndexedStack(
            index: _selectedIndex,
            children: _navItems.map((item) => item.screen).toList(),
          ),

          // Custom Bottom Navigation Bar
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: _navItems,
          ),
        ),
      ),
    );
  }
}
