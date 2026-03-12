import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/models/user_model.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:Quan_ly_thu_chi_PRM/services/user_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpForm extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpForm({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isAgreed = true;
  bool _showPasswords = false;
  bool _isLoading = false;

  // Error state for each field
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  Future<void> _validateForm() async {
    setState(() {
      _usernameError = FormValidators.validateName(
        widget.usernameController.text,
      );
      _emailError = FormValidators.validateEmail(widget.emailController.text);
      _passwordError = FormValidators.validatePassword(
        widget.passwordController.text,
      );
      _confirmPasswordError = FormValidators.validatePasswordMatch(
        widget.passwordController.text,
        widget.confirmPasswordController.text,
      );
    });

    final isFormValid =
        _usernameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _isAgreed;

    if (!isFormValid) {
      if (!_isAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please agree to Terms and Conditions'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text;
    final username = widget.usernameController.text.trim();

    UserCredential? cred;
    try {
      cred = await FirebaseAuthService().signUpWithEmailPassword(
        email: email,
        password: password,
        displayName: username,
      );

      final uid = cred.user!.uid;
      final user = UserModel(
        uid: uid,
        name: username,
        email: email,
        createdAt: DateTime.now().toUtc().toIso8601String(),
      );

      // firebase_database is not supported on Windows/macOS/Linux desktop
      final isDesktop = !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.windows ||
           defaultTargetPlatform == TargetPlatform.macOS ||
           defaultTargetPlatform == TargetPlatform.linux);
      if (!isDesktop) {
        await UserDatabaseService().createUser(user);
      }
      await FirebaseAuthService().sendEmailVerification();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.emailVerification,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? e.code),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (e) {
      // If DB write failed after Auth succeeded, roll back by deleting the Auth user.
      await cred?.user?.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Real-time validation for name field
  void _validateNameRealTime(String value) {
    setState(() {
      _usernameError = FormValidators.validateName(value);
    });
  }

  // Real-time validation for email field
  void _validateEmailRealTime(String value) {
    setState(() {
      _emailError = FormValidators.validateEmail(value);
    });
  }

  // Real-time validation for password field
  void _validatePasswordRealTime(String value) {
    setState(() {
      _passwordError = FormValidators.validatePassword(value);
      // Also revalidate confirm password if it has content
      if (widget.confirmPasswordController.text.isNotEmpty) {
        _confirmPasswordError = FormValidators.validatePasswordMatch(
          value,
          widget.confirmPasswordController.text,
        );
      }
    });
  }

  // Real-time validation for confirm password field
  void _validateConfirmPasswordRealTime(String value) {
    setState(() {
      _confirmPasswordError = FormValidators.validatePasswordMatch(
        widget.passwordController.text,
        value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            Images.signupLogo,
            height: 165,
            width: 213,
            fit: BoxFit.contain,
          ),
        ),

        AppGap.h32,

        // Name field
        CustomTextField(
          controller: widget.usernameController,
          hintText: widget.username,
          errorText: _usernameError,
          onChanged: _validateNameRealTime,
          onBlur: () => _validateNameRealTime(widget.usernameController.text),
        ),

        AppGap.h20,

        // Email field
        CustomTextField(
          controller: widget.emailController,
          hintText: widget.email,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          onChanged: _validateEmailRealTime,
          onBlur: () => _validateEmailRealTime(widget.emailController.text),
        ),

        AppGap.h20,

        // Password field
        CustomTextField(
          controller: widget.passwordController,
          hintText: widget.password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_showPasswords,
          isPassword: false,
          errorText: _passwordError,
          onChanged: _validatePasswordRealTime,
          onBlur: () =>
              _validatePasswordRealTime(widget.passwordController.text),
          suffixIcon: IconButton(
            icon: Icon(
              _showPasswords ? Icons.visibility : Icons.visibility_off,
              color: AppColors.lightGray,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showPasswords = !_showPasswords;
              });
            },
          ),
        ),

        AppGap.h20,

        // Confirm Password field
        CustomTextField(
          controller: widget.confirmPasswordController,
          hintText: 'sign_up.confirm_password'.tr(),
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_showPasswords,
          isPassword: false,
          errorText: _confirmPasswordError,
          onChanged: _validateConfirmPasswordRealTime,
          onBlur: () => _validateConfirmPasswordRealTime(
            widget.confirmPasswordController.text,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _showPasswords ? Icons.visibility : Icons.visibility_off,
              color: AppColors.lightGray,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showPasswords = !_showPasswords;
              });
            },
          ),
        ),

        AppGap.h12,

        // Checkbox with Terms and Conditions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    _isAgreed = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(color: AppColors.lightGray, width: 1.5),
              ),
            ),
            AppGap.w12,

            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle.s14.copyWith(
                    color: context.primaryTextColor,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'sign_up.text_checkbox'.tr()),
                    TextSpan(
                      text: 'sign_up.term_n_conditions'.tr(),
                      style: AppTextStyle.s14.copyWith(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        AppGap.h40,

        // Sign Up Button
        PrimaryButton(
          text: 'sign_up.signup_button'.tr(),
          color: AppColors.mainColor,
          onClick: _validateForm,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
