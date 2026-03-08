import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/widgets/verify_forgot_password_form.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Redirect screen for forgot password verification
/// This screen receives the email and immediately navigates to ResetPasswordScreen
class VerifyForgotPasswordScreen extends StatefulWidget {
  final String email;

  const VerifyForgotPasswordScreen({super.key, required this.email});

  @override
  State<VerifyForgotPasswordScreen> createState() =>
      _VerifyForgotPasswordScreenState();
}

class _VerifyForgotPasswordScreenState extends State<VerifyForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    _redirectToResetPassword();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also check route arguments in case they're passed separately
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String) {
      _redirectToResetPassword(email: arg);
    }
  }

  void _redirectToResetPassword({String? email}) {
    final emailToUse = email ?? widget.email;
    if (emailToUse.isNotEmpty && mounted) {
      Future.microtask(() {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.resetPassword,
            arguments: emailToUse,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
