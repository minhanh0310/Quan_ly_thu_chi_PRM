import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/widgets/verify_forgot_password_form.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/auth/change_password/screens/change_password_screen.dart';

class VerifyForgotPasswordScreen extends StatefulWidget {
  const VerifyForgotPasswordScreen({super.key});

  @override
  State<VerifyForgotPasswordScreen> createState() =>
      _VerifyForgotPasswordScreenState();
}

class _VerifyForgotPasswordScreenState
    extends State<VerifyForgotPasswordScreen> {
  final _verifyCodeController = TextEditingController();

  @override
  void dispose() {
    _verifyCodeController.dispose();
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
          appBar: CustomAppBar(title: 'Forgot Password'),
          body: Column(
            children: [
              Expanded(
                child: _Body(verifyCodeController: _verifyCodeController),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.forgotPw);
                },
                child: Text(
                  'Change your phone number',
                  style: AppTextStyle.s12.copyWith(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TextEditingController verifyCodeController;

  const _Body({required this.verifyCodeController});

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

            VerifyForgotPasswordForm(
              verifyCodeController: verifyCodeController,
            ),

            AppGap.h24,

            RichText(
              text: TextSpan(
                style: AppTextStyle.s14.copyWith(
                  color: AppColors.gray,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'We texted you a code to verify your phone number ',
                  ),
                  TextSpan(
                    text: '(+84) 0123456xxx',
                    style: AppTextStyle.s14.copyWith(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.mainColor,
                    ),
                  ),
                ],
              ),
            ),

            AppGap.h16,

            Text(
              'This code will expired in 5 minutes after this message.',
              style: AppTextStyle.s14.copyWith(color: AppColors.gray),
            ),

            AppGap.h40,

            PrimaryButton(
              text: 'Change password',
              onClick: () {
                // Validate code
                final code = verifyCodeController.text;
                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter verification code'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Navigate to change password screen
                Navigator.pushNamed(context, AppRoutes.changePw);
                // TODO: validate code and navigate to change password screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
