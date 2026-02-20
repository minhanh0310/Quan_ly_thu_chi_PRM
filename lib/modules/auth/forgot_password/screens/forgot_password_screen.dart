import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/widgets/auth_redirect_text.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
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
              Expanded(
                child: _Body(phoneNumberController: _phoneNumberController),
              ),

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
  final TextEditingController phoneNumberController;

  const _Body({required this.phoneNumberController});

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

            ForgotPasswordForm(phoneNumberController: phoneNumberController),

            AppGap.h40,

            PrimaryButton(
              text: 'Send',
              onClick: () {
                // Validate phone number
                final phoneNumber = phoneNumberController.text;
                if (phoneNumber.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your phone number'),
                      backgroundColor: Colors.red,
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
