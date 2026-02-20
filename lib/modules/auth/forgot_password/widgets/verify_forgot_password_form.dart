import 'package:Quan_ly_thu_chi_PRM/init.dart';

class VerifyForgotPasswordForm extends StatelessWidget {
  final TextEditingController verifyCodeController;

  const VerifyForgotPasswordForm({
    super.key,
    required this.verifyCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Type a code',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),

        AppGap.h16,

        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                controller: verifyCodeController,
                hintText: 'Enter code',
                keyboardType: TextInputType.number,
              ),
            ),
            AppGap.w12,

            Container(
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: AppPad.h24v10,
              child: Text(
                'Resend',
                style: AppTextStyle.s14.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}