import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';

class ResetPasswordForm extends StatefulWidget {
  final TextEditingController codeController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final String email;
  final VoidCallback? onManualPaste;

  const ResetPasswordForm({
    super.key,
    required this.codeController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.email,
    this.onManualPaste,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  String? _codeError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  void _validateCodeRealTime(String value) {
    setState(() {
      _codeError = value.isEmpty ? 'Code is required' : null;
    });
  }

  void _validateNewPasswordRealTime(String value) {
    setState(() {
      _newPasswordError = FormValidators.validatePassword(value);
    });
  }

  void _validateConfirmPasswordRealTime(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (value != widget.newPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email display
        Text(
          'Verification email sent to:',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGap.h8,
        Text(
          widget.email,
          style: AppTextStyle.s14.copyWith(
            color: AppColors.mainColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGap.h24,

        // Instructions
        Text(
          'How to fill the code:',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGap.h8,
        Text(
          'Please check your spam folder and copy the verification code from the password reset email link and paste it below. DO NOT open the link in a browser, just copy the reset link and paste it here.',
          style: AppTextStyle.s12.copyWith(
            color: context.secondaryTextColor,
            height: 1.5,
          ),
        ),
        AppGap.h20,

        // Code field
        Text(
          'Verification Code',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGap.h8,
        CustomTextField(
          controller: widget.codeController,
          hintText: 'Paste verification code here',
          keyboardType: TextInputType.text,
          errorText: _codeError,
          onChanged: _validateCodeRealTime,
          onBlur: () => _validateCodeRealTime(widget.codeController.text),
        ),
        if (widget.codeController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: widget.onManualPaste,
              child: Text(
                'Need help extracting the code? Paste the full email link',
                style: AppTextStyle.s12.copyWith(
                  color: AppColors.mainColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        AppGap.h24,

        // New Password field
        Text(
          'New Password',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGap.h8,
        Stack(
          alignment: Alignment.centerRight,
          children: [
            CustomTextField(
              controller: widget.newPasswordController,
              hintText: 'Enter new password',
              obscureText: !_showNewPassword,
              errorText: _newPasswordError,
              onChanged: _validateNewPasswordRealTime,
              onBlur: () => _validateNewPasswordRealTime(widget.newPasswordController.text),
            ),
            if (widget.newPasswordController.text.isNotEmpty)
              Positioned(
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _showNewPassword = !_showNewPassword);
                  },
                  child: Icon(
                    _showNewPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.grey,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        AppGap.h20,

        // Confirm Password field
        Text(
          'Confirm Password',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGap.h8,
        Stack(
          alignment: Alignment.centerRight,
          children: [
            CustomTextField(
              controller: widget.confirmPasswordController,
              hintText: 'Confirm new password',
              obscureText: !_showConfirmPassword,
              errorText: _confirmPasswordError,
              onChanged: _validateConfirmPasswordRealTime,
              onBlur: () => _validateConfirmPasswordRealTime(widget.confirmPasswordController.text),
            ),
            if (widget.confirmPasswordController.text.isNotEmpty)
              Positioned(
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _showConfirmPassword = !_showConfirmPassword);
                  },
                  child: Icon(
                    _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.grey,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        AppGap.h20,

        // Password requirements note
        Text(
          'Password must be at least 6 characters with uppercase, lowercase, number, and special character',
          style: AppTextStyle.s10.copyWith(
            color: context.secondaryTextColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
