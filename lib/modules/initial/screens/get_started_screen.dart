import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              AppGap.h60,

              _buildHeader(context),

              AppGap.h40,

              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      context: context,
                      bgColor: context.surfaceVariant,
                      icon: Icons.language,
                      iconColor: AppColors.white,
                      iconBgColor: Color(0xff0890FE),
                      title: 'onboarding.global'.tr(),
                      subtitle: 'onboarding.st_global'.tr(),
                    ),
                  ),
                  AppGap.w16,
                  Expanded(
                    child: _buildFeatureCard(
                      context: context,
                      bgColor: context.surfaceVariant,
                      icon: Icons.check_sharp,
                      iconColor: AppColors.white,
                      iconBgColor: AppColors.green,
                      title: 'onboarding.simple'.tr(),
                      subtitle: 'onboarding.st_simple'.tr(),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              PrimaryButton(
                text: 'onboarding.get_started'.tr(),
                onClick: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
              ),

              AppGap.h20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Opacity(
            opacity: 0.1,
            child: Image.asset(
              Images.walletLogo,
              height: 170,
              width: 170,
              fit: BoxFit.contain,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'onboarding.header1'.tr(),
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'onboarding.header2'.tr(),
                    style: TextStyle(color: Color(0xFF5B4EE5)),
                  ),
                ],
              ),
            ),

            AppGap.h12,

            Text('onboarding.sub_header'.tr(),
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),

          AppGap.h16,

          Text(
            title,
            style: AppTextStyle.s16.copyWith(
              color: context.primaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          AppGap.h8,

          Text(
            subtitle,
            style: AppTextStyle.s12.copyWith(color: context.secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
