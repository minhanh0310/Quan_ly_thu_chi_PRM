import 'package:Quan_ly_thu_chi_PRM/init.dart';

class ForgotPasswordForm extends StatelessWidget {
  final TextEditingController phoneNumberController;

  const ForgotPasswordForm({
    super.key,
    required this.phoneNumberController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text( 
          'Type your phone number',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.gray,
            fontWeight: FontWeight.w600,
          ),
        ),

        AppGap.h16,

        CustomTextField(
          controller: phoneNumberController,
          hintText: '(+84) Phone number',
          keyboardType: TextInputType.phone,
        ),

        AppGap.h24,

        Text(
          'We will text you a code to verify your phone number',
          style: AppTextStyle.s14.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}