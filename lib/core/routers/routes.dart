import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_up/screen/sign_up_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/splash_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/forgot_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/verify_forgot_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_pw_successfully_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/screen/home_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/onboarding_currency_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/screen/dashboard_screen.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/ledger/screen/ledger_screen.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/plans/screen/plans_screen.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/stats/screen/stats_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPw = '/forgot-password';
  static const String verifyForgotPw = '/verify-forgot-password';
  static const String changePw = '/change-password';
  static const String changePwSuccess = "/changePwSuccess";
  static const String home = "/home";
  static const String onboardingCurrency = "/onboardingCurrency";
  static const String dashboard = "/dashboard";
  static const String ledger = "/ledger";
  static const String plans = "/plans";
  static const String stats = "/stats";
  
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    signin: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    forgotPw: (context) => const ForgotPasswordScreen(),
    verifyForgotPw: (context) => const VerifyForgotPasswordScreen(),
    changePw: (context) => const ChangePasswordScreen(),
    changePwSuccess: (context) => const ChangePwSuccessfullyScreen(),
    home: (context) => const HomeScreen(),
    onboardingCurrency: (context) => const OnboardingCurrencyScreen(),
    dashboard: (context) => const DashboardScreen(),
    // ledger: (context) => const LedgerScreen(),
    // plans: (context) => const PlansScreen(),
    // stats: (context) => const StatsScreen(),
  };
}
