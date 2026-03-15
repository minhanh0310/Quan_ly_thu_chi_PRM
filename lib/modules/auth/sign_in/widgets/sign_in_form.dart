import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/models/user_model.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:Quan_ly_thu_chi_PRM/services/user_database_service.dart';
import 'package:Quan_ly_thu_chi_PRM/services/remember_me_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';
import 'package:easy_localization/easy_localization.dart';

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
      final cred = await auth.signInWithEmailPasswordAndRemember(
        email: email,
        password: password,
        rememberMe: _rememberAccount,
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

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final auth = FirebaseAuthService();
    try {
      final (userCred, isNewUser) = await auth.signInWithGoogle();
      if (!mounted) return;

      // Remember this Google account for auto-login
      try {
        await RememberMeService().saveGoogleAccount(
          email: userCred.user!.email!,
        );
      } catch (_) {
        // Silently ignore if saving fails
      }

      if (isNewUser) {
        // New Google user → create DB record → onboarding
        final user = userCred.user!;
        final isDesktop = !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.windows ||
                defaultTargetPlatform == TargetPlatform.macOS ||
                defaultTargetPlatform == TargetPlatform.linux);
        if (!isDesktop) {
          await UserDatabaseService().createUser(
            UserModel(
              uid: user.uid,
              name: user.displayName ?? user.email!.split('@').first,
              email: user.email!,
              createdAt: DateTime.now().toUtc().toIso8601String(),
              photoUrl: user.photoURL,
            ),
          );
        }
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.onboardingCurrency,
          (route) => false,
        );
      } else {
        // Existing Google user → go to dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.dashboard,
          (route) => false,
        );
      }
    } on GoogleLinkingRequiredException catch (e) {
      if (!mounted) return;
      _showLinkingDialog(e.email, e.googleCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'cancelled') return;
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
          content: Text('Google sign-in failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLinkingDialog(String email, AuthCredential googleCredential) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'sign_in.link_accounts_title'.tr(),
            style: TextStyle(color: dialogContext.primaryTextColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'sign_in.link_accounts_message'.tr(
                  namedArgs: {'email': email},
                ),
                style: AppTextStyle.s14in.copyWith(
                  color: dialogContext.secondaryTextColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'sign_in.password'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a12,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('common.cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                final password = passwordController.text;
                Navigator.pop(dialogContext);
                _linkAccounts(email, password, googleCredential);
              },
              child: Text(
                'sign_in.link_button'.tr(),
                style: TextStyle(color: dialogContext.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _linkAccounts(
    String email,
    String password,
    AuthCredential googleCredential,
  ) async {
    setState(() => _isLoading = true);
    try {
      final (userCred, googlePhotoUrl) =
          await FirebaseAuthService().linkGoogleToExistingAccount(
        email: email,
        password: password,
        googleCredential: googleCredential,
      );
      // Update DB with Google photo URL; existing display name is preserved.
      if (googlePhotoUrl != null) {
        await UserDatabaseService().updateUserPhotoUrl(
          userCred.user!.uid,
          googlePhotoUrl,
        );
      }
      // Remember this Google account for auto-login
      try {
        await RememberMeService().saveGoogleAccount(
          email: userCred.user!.email!,
        );
      } catch (_) {
        // Silently ignore if saving fails
      }
      if (!mounted) return;
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      'sign_in.remember_account'.tr(),
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
                'sign_in.forgot_password'.tr(),
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
          text: 'sign_in.signin_button'.tr(),
          color: AppColors.mainColor,
          onClick: _validateForm,
          isLoading: _isLoading,
        ),

        AppGap.h24,

        // OR divider
        Row(
          children: [
            Expanded(child: Divider(color: context.dividerColor)),
            Padding(
              padding: AppPad.h12,
              child: Text(
                'sign_in.or_divider'.tr(),
                style: AppTextStyle.s14.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
            Expanded(child: Divider(color: context.dividerColor)),
          ],
        ),

        AppGap.h24,

        // Google Sign-In Button
        Center(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _handleGoogleSignIn,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(240, 52),
              side: BorderSide(color: context.dividerColor),
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.a12,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/google_logo.svg',
              width: 20,
              height: 20,
            ),
            label: Text(
              'sign_in.google_signin'.tr(),
              style: AppTextStyle.s16.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
