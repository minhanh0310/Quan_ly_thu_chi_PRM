import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';

class SignInForm extends StatefulWidget {
  final String email;
  final String password;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignInForm({
    super.key,
    required this.email,
    required this.password,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _showPassword = false;
  bool _rememberAccount = true;
  bool _isLoading = false;

  // Error state for each field
  String? _emailError;
  String? _passwordError;

  Future<void> _validateForm() async {
    setState(() {
      // _emailError = FormValidators.validateEmail(widget.emailController.text);
      // _passwordError = FormValidators.validatePassword(
      //   widget.passwordController.text,
      // );
    });

    final isFormValid = _emailError == null && _passwordError == null;
    if (!isFormValid) return;

    setState(() => _isLoading = true);

    final auth = FirebaseAuthService();
    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text;

    try {
      final cred = await auth.signInWithEmailPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (cred.user?.emailVerified != true) {
        // Re-send the verification email while the user is still signed in,
        // then sign them out and redirect.
        try {
          await auth.sendEmailVerification();
        } catch (_) {
          // Best-effort — ignore if rate-limited
        }
        await auth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'A new verification link has been sent to your email.'
              ' Please verify before signing in.',
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.emailVerification,
          (route) => false,
          arguments: email,
        );
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            Images.lockLogo,
            height: 165,
            width: 213,
            fit: BoxFit.contain,
          ),
        ),

        AppGap.h32,

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
          obscureText: !_showPassword,
          isPassword: false,
          errorText: _passwordError,
          onChanged: _validatePasswordRealTime,
          onBlur: () =>
              _validatePasswordRealTime(widget.passwordController.text),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.lightGray,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),

        AppGap.h12,

        // Remember Account Checkbox & Forgot Password Row
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberAccount,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberAccount = value ?? false;
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
                    child: Text(
                      'Remember account',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.s14.copyWith(
                        color: context.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.forgotPw);
              },
              child: Text(
                'Forgot your password?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: AppTextStyle.s12.copyWith(
                  color: AppColors.lightGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        AppGap.h40,

        // Sign In Button
        PrimaryButton(
          text: 'Sign In',
          color: AppColors.mainColor,
          onClick: _validateForm,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
