import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_in/screen/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.blackBackground : AppColors.mainColor,
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Images.splashLogo,
                height: 200,
                width: 200,
                fit: BoxFit.contain,
                color: AppColors.white,
              ),

              AppGap.h15,

              Text('E-Money',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),

              AppGap.h5,

              Text('Manage Your Expense',
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),

              AppGap.h40,

              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                icon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffF5F6FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xff1D1E20),
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
