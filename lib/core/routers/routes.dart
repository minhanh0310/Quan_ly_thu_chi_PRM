import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_up/screen/sign_up_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/splash_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/forgot_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/screens/verify_forgot_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_password_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_pw_successfully_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPw = '/forgot-password';
  static const String verifyForgotPw = '/verify-forgot-password';
  static const String changePw = '/change-password';
  static const String changePwSuccess = "/changePwSuccess";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    signin: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    forgotPw: (context) => const ForgotPasswordScreen(),
    verifyForgotPw: (context) => const VerifyForgotPasswordScreen(),
    changePw: (context) => const ChangePasswordScreen(),
    changePwSuccess: (context) => const ChangePwSuccessfullyScreen()
  };
}
