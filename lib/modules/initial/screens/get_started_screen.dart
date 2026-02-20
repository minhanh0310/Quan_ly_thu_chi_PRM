import 'package:Quan_ly_thu_chi_PRM/init.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              AppGap.h60,

              _buildHeader(),

              AppGap.h40,

              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      bgColor: Color(0xffE3EEEF),
                      icon: Icons.language,
                      iconColor: AppColors.white,
                      iconBgColor: Color(0xff0890FE),
                      title: 'Global',
                      subtitle: 'Multi-currency support',
                    ),
                  ),
                  AppGap.w16,
                  Expanded(
                    child: _buildFeatureCard(
                      bgColor: Color(0xffE3EEEF),
                      icon: Icons.check_sharp,
                      iconColor: AppColors.white,
                      iconBgColor: AppColors.green,
                      title: 'Simple',
                      subtitle: 'Clean & intuitive UI',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              PrimaryButton(
                text: 'Get Started',
                onClick: () {
                  Navigator.pushNamed(context, AppRoutes.onboardingCurrency);
                },
              ),

              AppGap.h20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'Master Your ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Finances',
                    style: TextStyle(color: Color(0xFF5B4EE5)),
                  ),
                ],
              ),
            ),

            AppGap.h12,

            const Text(
              'Track income, plan for your dream home,\nand reach your financial goals with ease.',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
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
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),

          AppGap.h8,

          Text(
            subtitle,
            style: AppTextStyle.s12.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
