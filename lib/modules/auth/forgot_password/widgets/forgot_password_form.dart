import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';

class ForgotPasswordForm extends StatefulWidget {
  final TextEditingController emailController;

  const ForgotPasswordForm({super.key, required this.emailController});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String? _emailError;

  void _validateEmailRealTime(String value) {
    setState(() {
      _emailError = FormValidators.validateEmail(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Type your email address',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),

        AppGap.h16,

        CustomTextField(
          controller: widget.emailController,
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          onChanged: _validateEmailRealTime,
          onBlur: () => _validateEmailRealTime(widget.emailController.text),
        ),

        AppGap.h24,

        Text(
          'We will send you a reset link to verify your email address',
          style: AppTextStyle.s14.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}
