import 'package:Quan_ly_thu_chi_PRM/init.dart';

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
                'Change password successfully!',
                style: AppTextStyle.s20.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),

              AppGap.h24,

              Text(
                '''You have successfully changed password.\nPlease use the new password when Sign in''',
                style: AppTextStyle.s14.copyWith(color: context.primaryTextColor),
                textAlign: TextAlign.center,
              ),

              AppGap.h32,

              Padding(
                padding: AppPad.h24,
                child: PrimaryButton(
                  text: 'Ok',
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
