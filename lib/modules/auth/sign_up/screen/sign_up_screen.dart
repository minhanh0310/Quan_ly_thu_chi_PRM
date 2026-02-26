// import 'package:flutter/widgets.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_up/widgets/sign_up_form.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_header.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_redirect_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: isDark ? AppColors.blackBackground : AppColors.white,
          appBar: AuthAppBar(
            title: 'Sign Up',
            backgroundColor: AppColors.mainColor,
            iconColor: AppColors.white,
            titleColor: AppColors.white,
          ),
          body: Column(
            children: [
              Expanded(
                child: Body(
                  usernameController: _usernameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                ),
              ),

              AuthRedirectText(
                text: 'Have an account?',
                btnText: 'Sign In',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const Body({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPad.h24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGap.h32,

          AuthHeader(
            title: 'Welcome to us',
            subtitle: 'Hello there, create new account',
          ),

          AppGap.h32,

          SignUpForm(
            username: 'Name',
            email: 'Email',
            password: 'Password',
            usernameController: usernameController,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
          ),
        ],
      ),
    );
  }
}
