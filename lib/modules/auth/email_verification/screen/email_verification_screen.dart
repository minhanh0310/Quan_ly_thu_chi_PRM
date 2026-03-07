import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _authService = FirebaseAuthService();
  final _appLinks = AppLinks();

  // Email passed as route arg (from sign-in unverified flow, where user is
  // already signed out before navigation). Falls back to currentUser.email
  // for the post-sign-up flow where the user is still authenticated.
  String _email = '';

  Timer? _pollTimer;
  StreamSubscription<Uri>? _linkSub;
  bool _isResending = false;
  bool _canResend = false;
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prefer the route argument (set when navigating from the unverified sign-in
    // path, where the user is already signed out). Fall back to the live
    // currentUser email for the post-sign-up path.
    final arg = ModalRoute.of(context)?.settings.arguments;
    final argEmail = arg is String ? arg : null;
    _email = argEmail ?? _authService.currentUser?.email ?? '';
  }

  @override
  void initState() {
    super.initState();
    _startPolling();
    _startResendCountdown();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    _linkSub?.cancel();
    super.dispose();
  }

  /// Handles both the initial deep link (app opened from cold state by a link)
  /// and any subsequent incoming links while the screen is active.
  Future<void> _initDeepLinks() async {
    // Check if app was launched by a deep link (cold start).
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      await _handleIncomingUri(initialUri);
    }

    // Listen while screen is open (warm/hot start).
    _linkSub = _appLinks.uriLinkStream.listen(
      _handleIncomingUri,
      onError: (_) {},
    );
  }

  /// Processes an incoming URI.
  /// Accepts:
  ///   • Firebase action URL → extracts oobCode, applies it server-side
  ///   • Custom scheme fallback: jarsflow://email-verified → reload & advance
  Future<void> _handleIncomingUri(Uri uri) async {
    final oobCode = uri.queryParameters['oobCode'];
    final mode = uri.queryParameters['mode'];

    if (mode == 'verifyEmail' && oobCode != null) {
      // Full Firebase action URL received — apply the code in-app.
      try {
        await FirebaseAuth.instance.applyActionCode(oobCode);
        // Small delay to ensure backend updates propagate
        await Future.delayed(const Duration(milliseconds: 500));
        await _advanceIfVerified();
      } catch (_) {
        // Code already used or expired – fall back to normal reload.
        await Future.delayed(const Duration(milliseconds: 500));
        await _advanceIfVerified();
      }
    } else if (uri.scheme == 'jarsflow') {
      // Custom-scheme fallback — Firebase already verified on web, just reload.
      await _advanceIfVerified();
    }
  }

  Future<void> _advanceIfVerified() async {
    final verified = await _authService.reloadAndCheckVerified();
    if (verified && mounted) {
      _pollTimer?.cancel();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.onboardingCurrency,
        (route) => false,
      );
    }
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      final verified = await _authService.reloadAndCheckVerified();
      if (verified && mounted) {
        _pollTimer?.cancel();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.onboardingCurrency,
          (route) => false,
        );
      }
    });
  }

  void _startResendCountdown() {
    _canResend = false;
    _resendCountdown = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  Future<void> _resendEmail() async {
    if (!_canResend || _isResending) return;
    setState(() => _isResending = true);
    try {
      await _authService.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent!')),
      );
      _startResendCountdown();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  Future<void> _cancelAndGoBack() async {
    _pollTimer?.cancel();
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.signup,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AuthAppBar(
          title: 'Verify Email',
          backgroundColor: AppColors.mainColor,
          iconColor: AppColors.white,
          titleColor: AppColors.white,
          onBackPressed: _cancelAndGoBack,
        ),
        body: Padding(
          padding: AppPad.h24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppGap.h48,

              // Lock illustration
              Image.asset(
                Images.lockLogo,
                height: 160,
                width: 160,
                fit: BoxFit.contain,
              ),

              AppGap.h32,

              Text(
                'Check your inbox',
                style: AppTextStyle.s24.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),

              AppGap.h12,

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyle.s14.copyWith(
                    color: context.primaryTextColor,
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(
                      text: 'We sent a verification link to\n',
                    ),
                    TextSpan(
                      text: _email,
                      style: AppTextStyle.s14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '\n\nClick the link in the email to continue. This page will advance automatically once verified.',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Resend button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _canResend && !_isResending ? _resendEmail : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.mainColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    disabledForegroundColor:
                        AppColors.lightGray,
                  ),
                  child: _isResending
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.mainColor),
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _canResend
                              ? 'Resend Email'
                              : 'Resend in ${_resendCountdown}s',
                          style: AppTextStyle.s14.copyWith(
                            color: _canResend
                                ? AppColors.mainColor
                                : AppColors.lightGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              AppGap.h16,

              // Cancel / go back
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _cancelAndGoBack,
                  child: Text(
                    'Back to Sign Up',
                    style: AppTextStyle.s14.copyWith(
                      color: AppColors.lightGray,
                    ),
                  ),
                ),
              ),

              AppGap.h32,
            ],
          ),
        ),
      ),
    );
  }
}
