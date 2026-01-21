// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Để hỗ trợ tiếng Việt
import 'dashboard_screen.dart';
import 'report_screen.dart';
import 'add_transaction_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Thu Chi',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi', 'VN')], // Thiết lập tiếng Việt
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.robotoTextTheme(),
        useMaterial3: true,
      ),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = [
    const DashboardScreen(), // Index 0: Sổ giao dịch
    const ReportScreen(),    // Index 1: Báo cáo
    const AddTransactionScreen(), // Index 2: Nhập liệu
    const SettingsScreen(),       // Index 3: Cài đặt
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? AppBar(
        title: const Text("Sổ Thu Chi"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ) : null, // Chỉ hiện AppBar ở Dashboard, Report đã có AppBar riêng
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: Colors.orange.withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.book), label: 'Sổ cái'),
          NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Báo cáo'),
          NavigationDestination(icon: Icon(Icons.add_circle, size: 30, color: Colors.orange), label: 'Nhập'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Khác'),
        ],
      ),
    );
  }
}