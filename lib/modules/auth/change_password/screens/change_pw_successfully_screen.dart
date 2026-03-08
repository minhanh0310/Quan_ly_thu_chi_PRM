import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePwSuccessfullyScreen extends StatelessWidget {
  const ChangePwSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Images.changePwSuccessLogo,
                width: 327,
                height: 216,
                fit: BoxFit.contain,
              ),

              AppGap.h32,

              Text(
                'change_password.success_title'.tr(),
                style: AppTextStyle.s20.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),

              AppGap.h24,

              Text(
                '''change_password.success_message'''.tr(),
                style: AppTextStyle.s14.copyWith(color: context.primaryTextColor),
                textAlign: TextAlign.center,
              ),

              AppGap.h32,

              Padding(
                padding: AppPad.h24,
                child: PrimaryButton(
                  text: 'common.ok'.tr(),
                  onClick: () {
                    // TODO: Save data and navigate to home screen
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
