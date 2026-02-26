import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_redirect_text.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/widgets/forgot_password_form.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AuthAppBar(title: 'Forgot Password'),
          body: Column(
            children: [
              Expanded(child: _Body(emailController: _emailController)),

              AuthRedirectText(
                text: 'Remembered your password?',
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

class _Body extends StatelessWidget {
  final TextEditingController emailController;

  const _Body({required this.emailController});

  @override
  Widget build(BuildContext context) {
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
              text: 'Send',
              onClick: () {
                // Validate email
                final email = emailController.text;
                final emailError = FormValidators.validateEmail(email);

                if (emailError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(emailError),
                      backgroundColor: AppColors.error,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Navigate to verify screen
                Navigator.pushNamed(context, AppRoutes.verifyForgotPw);
              },
            ),
          ],
        ),
      ),
    );
  }
}
