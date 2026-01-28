import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/screens/sign_in_screen.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/auth/screens/signup_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgetPw = '/forget-password';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    signin: (context) => const SignInScreen(),
    // signup: (context) => const SignUpScreen(),
  };
}
