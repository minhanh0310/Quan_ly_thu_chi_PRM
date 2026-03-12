import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_redirect_text.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/widgets/forgot_password_form.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_header.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showBottomErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _handleSendResetEmail() async {
    // Validate email
    final email = _emailController.text.trim();
    final emailError = FormValidators.validateEmail(email);

    if (emailError != null) {
      if (!mounted) return;
      _showBottomErrorSnackBar(emailError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuthService().sendPasswordResetEmail(email: email);
      
      if (!mounted) return;
      
      // Navigate to reset password screen with email as argument
      Navigator.pushNamed(
        context,
        AppRoutes.verifyForgotPw,
        arguments: email,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email address';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Please try again later';
      } else {
        errorMessage = e.message ?? 'Failed to send reset email. Please try again';
      }
      
      _showBottomErrorSnackBar(errorMessage);
    } catch (e) {
      if (!mounted) return;
      _showBottomErrorSnackBar('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: AuthAppBar(
            title: 'forgot_password.title'.tr(),
            backgroundColor: context.primaryColor,
          ),
          body: Column(
            children: [
              Expanded(child: _Body(emailController: _emailController)),
              AuthRedirectText(
                text: 'forgot_password.remembered_pw'.tr(),
                btnText: 'sign_in.signin_button'.tr(),
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

  Widget _Body({required TextEditingController emailController}) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: AppPad.h40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppGap.h40,
            ForgotPasswordForm(emailController: emailController),
            AppGap.h40,
            PrimaryButton(
              text: 'forgot_password.send_code'.tr(),
              onClick: _handleSendResetEmail,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
