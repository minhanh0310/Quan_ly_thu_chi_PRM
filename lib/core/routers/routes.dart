import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/email_verification/screen/email_verification_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_up/screen/sign_up_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/splash_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/forgot_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/verify_forgot_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/reset_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_pw_successfully_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/home/screen/home_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/onboarding_currency_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/screen/dashboard_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/screen/ledger_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/screen/plans_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/screen/stats_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/settings/screen/general_settings_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPw = '/forgot-password';
  static const String verifyForgotPw = '/verify-forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePw = '/change-password';
  static const String changePwSuccess = "/changePwSuccess";
  static const String home = "/home";
  static const String emailVerification = "/email-verification";
  static const String onboardingCurrency = "/onboardingCurrency";
  static const String dashboard = "/dashboard";
  static const String ledger = "/ledger";
  static const String plans = "/plans";
  static const String stats = "/stats";
  static const String generalSettings = "/general-settings";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case forgotPw:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case verifyForgotPw:
        String email = '';
        if (settings.arguments != null && settings.arguments is String) {
          email = settings.arguments as String;
        }
        return MaterialPageRoute(
          builder: (_) => VerifyForgotPasswordScreen(email: email),
        );
      case resetPassword:
        String email = '';
        if (settings.arguments != null && settings.arguments is String) {
          email = settings.arguments as String;
        }
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: email),
        );
      case changePw:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case changePwSuccess:
        return MaterialPageRoute(builder: (_) => const ChangePwSuccessfullyScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case emailVerification:
        String? email;
        if (settings.arguments != null && settings.arguments is String) {
          email = settings.arguments as String;
        } else {
          email = null;
        }
        return MaterialPageRoute(
          builder: (_) => const EmailVerificationScreen(),
          settings: RouteSettings(arguments: email),
        );
      case onboardingCurrency:
        return MaterialPageRoute(builder: (_) => const OnboardingCurrencyScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case ledger:
        return MaterialPageRoute(builder: (_) => const LedgerScreen());
      case plans:
        return MaterialPageRoute(builder: (_) => const PlansScreen());
      case stats:
        return MaterialPageRoute(builder: (_) => const StatsScreen());
      case generalSettings:
        return MaterialPageRoute(builder: (_) => const GeneralSettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
