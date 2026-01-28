import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SignInForm extends StatelessWidget {
  final String phoneNumber;
  final String password;
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;

  const SignInForm({
    super.key,
    required this.phoneNumber,
    required this.password,
    required this.phoneNumberController,
    required this.passwordController,
  });

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

        CustomTextField(
          controller: phoneNumberController,
          hintText: phoneNumber,
        ),

        AppGap.h20,

        CustomTextField(
          controller: passwordController,
          hintText: password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
        ),

        AppGap.h12,

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.forgetPw);
              },
              child: Text(
                'Forgot your password?',
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
          onClick: () {
            // Navigator.pushNamed(context, AppRoutes.home);
          },
        ),
      ],
    );
  }
}
