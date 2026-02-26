import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';

class SignUpForm extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpForm({
    super.key,
    required this.username,
    required this.email,
    required this.password,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isAgreed = false;
  bool _showPasswords = false;

  // Error state for each field
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _validateForm() {
    setState(() {
      // Validate each field
      _usernameError = FormValidators.validateName(
        widget.usernameController.text,
      );
      _emailError = FormValidators.validateEmail(widget.emailController.text);
      _passwordError = FormValidators.validatePassword(
        widget.passwordController.text,
      );
      _confirmPasswordError = FormValidators.validatePasswordMatch(
        widget.passwordController.text,
        widget.confirmPasswordController.text,
      );
    });

    // Check if all fields are valid
    final isFormValid =
        _usernameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _isAgreed;

    if (isFormValid) {
      // All validations passed and terms agreed
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
    } else if (!_isAgreed) {
      // Show snackbar if terms not agreed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to Terms and Conditions'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Real-time validation for name field
  void _validateNameRealTime(String value) {
    setState(() {
      _usernameError = FormValidators.validateName(value);
    });
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
      // Also revalidate confirm password if it has content
      if (widget.confirmPasswordController.text.isNotEmpty) {
        _confirmPasswordError = FormValidators.validatePasswordMatch(
          value,
          widget.confirmPasswordController.text,
        );
      }
    });
  }

  // Real-time validation for confirm password field
  void _validateConfirmPasswordRealTime(String value) {
    setState(() {
      _confirmPasswordError = FormValidators.validatePasswordMatch(
        widget.passwordController.text,
        value,
      );
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
            Images.signupLogo,
            height: 165,
            width: 213,
            fit: BoxFit.contain,
          ),
        ),

        AppGap.h32,

        // Name field
        CustomTextField(
          controller: widget.usernameController,
          hintText: widget.username,
          errorText: _usernameError,
          onChanged: _validateNameRealTime,
          onBlur: () => _validateNameRealTime(widget.usernameController.text),
        ),

        AppGap.h20,

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
          obscureText: !_showPasswords,
          isPassword: false,
          errorText: _passwordError,
          onChanged: _validatePasswordRealTime,
          onBlur: () =>
              _validatePasswordRealTime(widget.passwordController.text),
          suffixIcon: IconButton(
            icon: Icon(
              _showPasswords ? Icons.visibility : Icons.visibility_off,
              color: AppColors.lightGray,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showPasswords = !_showPasswords;
              });
            },
          ),
        ),

        AppGap.h20,

        // Confirm Password field
        CustomTextField(
          controller: widget.confirmPasswordController,
          hintText: 'Confirm Password',
          keyboardType: TextInputType.visiblePassword,
          obscureText: !_showPasswords,
          isPassword: false,
          errorText: _confirmPasswordError,
          onChanged: _validateConfirmPasswordRealTime,
          onBlur: () => _validateConfirmPasswordRealTime(
            widget.confirmPasswordController.text,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _showPasswords ? Icons.visibility : Icons.visibility_off,
              color: AppColors.lightGray,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showPasswords = !_showPasswords;
              });
            },
          ),
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
                  style: AppTextStyle.s14.copyWith(
                    color: AppColors.black,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'By creating an account you agree to our '),
                    TextSpan(
                      text: 'Term and Conditions',
                      style: AppTextStyle.s14.copyWith(
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
          onClick: _validateForm,
        ),
      ],
    );
  }
}
