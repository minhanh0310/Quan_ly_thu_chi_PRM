import 'package:Quan_ly_thu_chi_PRM/init.dart';
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

  // Error state for each field
  String? _emailError;
  String? _passwordError;

  void _validateForm() {
    setState(() {
      // Validate each field
      // _emailError = FormValidators.validateEmail(widget.emailController.text);
      // _passwordError = FormValidators.validatePassword(
      //   widget.passwordController.text,
      // );
    });

    // Check if all fields are valid
    final isFormValid = _emailError == null && _passwordError == null;

    if (isFormValid) {
      // All validations passed, proceed to login
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remember Account Checkbox
            Row(
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
                Text(
                  'Remember account',
                  style: AppTextStyle.s14.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Forgot Password Link
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.forgotPw);
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
          onClick: _validateForm,
        ),
      ],
    );
  }
}
