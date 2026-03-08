import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';

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
          'change_password.new_password'.tr(),
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        AppGap.h8,
        CustomTextField(controller: newPwController, isPassword: true),

        AppGap.h20,

        Text(
          'change_password.confirm_password'.tr(),
          style: AppTextStyle.s12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),

        AppGap.h8,
        CustomTextField(controller: confirmPwController, isPassword: true),

        AppGap.h40,

        PrimaryButton(
          text: 'change_password.change_button'.tr(),
          onClick: () {
            // Validation
            final newPassword = newPwController.text.trim();
            final confirmPassword = confirmPwController.text.trim();

            if (newPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('change_password.new_password_empty'.tr()),
                  backgroundColor: AppColors.error,
                ),
              );
              return;
            }

            if (confirmPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('change_password.confirm_password_empty'.tr()),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }

            if (newPassword != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('change_password.pw_unmatch'.tr()),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 2),
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
