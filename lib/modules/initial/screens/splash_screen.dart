import 'package:Quan_ly_thu_chi_PRM/init.dart';
// import 'package:Quan_ly_thu_chi_PRM/modules/auth/sign_in/screen/sign_in_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/screens/get_started_screen.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:Quan_ly_thu_chi_PRM/services/remember_me_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    // User must click the arrow button to proceed
  }

  /// Attempts to auto-login with saved credentials
  Future<void> _handleAutoLogin() async {
    try {
      final rememberMe = RememberMeService();
      final providerType = await rememberMe.getProviderType();

      // Try Google silent sign-in first
      if (providerType == 'google') {
        final result = await _tryGoogleSilentSignIn();
        if (result) return;
        // If silent sign-in fails, clear Google account and continue
        await rememberMe.clearCredentials();
      }

      // Try email/password sign-in
      final hasCredentials = await rememberMe.hasCredentials();
      if (!hasCredentials) {
        _navigateToGetStarted();
        return;
      }

      final credentials = await rememberMe.getCredentials();
      if (credentials == null) {
        _navigateToGetStarted();
        return;
      }

      // Attempt auto-login with email/password
      final cred = await _auth.signInWithEmailPassword(
        email: credentials.email,
        password: credentials.password,
      );

      if (!mounted) return;

      // Check email verification
      if (cred.user?.emailVerified != true) {
        await _auth.signOut();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.emailVerification,
          (route) => false,
          arguments: credentials.email,
        );
        return;
      }

      // Email verified, proceed to dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
    } catch (e) {
      print('Auto-login failed: $e');
      try {
        await RememberMeService().clearCredentials();
      } catch (_) {}
      if (mounted) {
        _navigateToGetStarted();
      }
    }
  }

  /// Attempts silent sign-in with Google
  Future<bool> _tryGoogleSilentSignIn() async {
    try {
      final result = await _auth.signInSilentlyWithGoogle();
      if (result == null) {
        // Silent sign-in not available (e.g., no cached account on native)
        return false;
      }

      final (userCred, _) = result;

      if (!mounted) return false;

      // Email is auto-verified for Google sign-in
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
      return true;
    } catch (e) {
      print('Google silent sign-in failed: $e');
      return false;
    }
  }

  void _navigateToGetStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const GetStartedScreen()),
    );
  }

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
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                color: AppColors.white,
              ),

              AppGap.h15,

              Text(
                'splash_screen.title'.tr(),
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),

              AppGap.h5,

              Text(
                'splash_screen.subtitle'.tr(),
                style: TextStyle(
                  fontFamily: AppTextStyle.fontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),

              AppGap.h40,

              IconButton(
                onPressed: () {
                  _handleAutoLogin();
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
