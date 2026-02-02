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
            // Validation
            final newPassword = newPwController.text.trim();
            final confirmPassword = confirmPwController.text.trim();

            // Kiểm tra password không được để trống
            if (newPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter new password'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            // Kiểm tra confirm password không được để trống
            if (confirmPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please confirm your password'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            if (newPassword != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Passwords do not match'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            Navigator.pushNamed(context, AppRoutes.changePwSuccess);
          },
        ),
      ],
    );
  }
}
