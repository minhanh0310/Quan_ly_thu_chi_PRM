// import 'package:flutter/widgets.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_in/widgets/sign_in_form.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_header.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_redirect_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
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
          appBar: AppBar(
            title: Text(
              'Sign In',
              style: AppTextStyle.s20.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.mainColor,
            elevation: 0,
            iconTheme: IconThemeData( 
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Body(
                  phoneNumberController: _phoneNumberController,
                  passwordController: _passwordController,
                ),
              ),

              AuthRedirectText(
                text: 'Don\'t have an account?',
                btnText: 'Sign Up',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
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
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;

  const Body({
    super.key,
    required this.phoneNumberController,
    required this.passwordController,
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
            title: 'Welcome Back!',
            subtitle: 'Hello there, sign in to continue',
          ),

          AppGap.h32,

          SignInForm(
            phoneNumber: 'Enter your phone number',
            password: 'Enter your password',
            phoneNumberController: phoneNumberController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
