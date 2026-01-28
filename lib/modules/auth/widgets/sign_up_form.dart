import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SignUpForm extends StatefulWidget {
  final String username;
  final String phoneNumber;
  final String password;
  final TextEditingController usernameController;
  final TextEditingController phoneNumberController;
  final TextEditingController passwordController;

  const SignUpForm({
    super.key,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.usernameController,
    required this.phoneNumberController,
    required this.passwordController,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isAgreed = false;

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

        CustomTextField(
          controller: widget.usernameController,
          hintText: widget.username,
        ),

        AppGap.h20,

        CustomTextField(
          controller: widget.phoneNumberController,
          hintText: widget.phoneNumber,
          keyboardType: TextInputType.phone,
        ),

        AppGap.h20,

        CustomTextField(
          controller: widget.passwordController,
          hintText: widget.password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
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
                  style: AppTextStyle.s12.copyWith(
                    color: AppColors.black,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'By creating an account you agree to our '),
                    TextSpan(
                      text: 'Term and Conditions',
                      style: AppTextStyle.s12.copyWith(
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
          text: 'Sign up',
          color: AppColors.mainColor,
          onClick: () {
            if (!_isAgreed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please agree to Terms and Conditions'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            // Navigator.pushNamed(context, AppRoutes.home);
          },
        ),
      ],
    );
  }
}
