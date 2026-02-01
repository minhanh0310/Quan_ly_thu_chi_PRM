import 'package:Quan_ly_thu_chi_PRM/init.dart';

class ChangePasswordForm extends StatelessWidget {
  final TextEditingController newPwController;
  final TextEditingController confirmPwController;

  const ChangePasswordForm({
    super.key,
    required this.newPwController,
    required this.confirmPwController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type your new password',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.gray,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppGap.h8,
        CustomTextField(controller: newPwController, isPassword: true),

        AppGap.h20,

        Text(
          'Confirm password',
          style: AppTextStyle.s12.copyWith(
            color: AppColors.gray,
            fontWeight: FontWeight.w400,
          ),
        ),

        AppGap.h8,
        CustomTextField(controller: confirmPwController, isPassword: true),

        AppGap.h40,

        PrimaryButton(
          text: 'Change Password',
          onClick: () {
            //TODO: Submit form
          },
        ),
      ],
    );
  }
}
