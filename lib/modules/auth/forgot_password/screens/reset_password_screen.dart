import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/auth/forgot_password/widgets/reset_password_form.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/validators/form_validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _email = '';
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _initDeepLinks();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _linkSub?.cancel();
    super.dispose();
  }

  /// Handles both the initial deep link and subsequent incoming links
  Future<void> _initDeepLinks() async {
    try {
      // Check if app was launched by a deep link (cold start)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleIncomingUri(initialUri);
      }

      // Listen for incoming links while screen is open
      _linkSub = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          _handleIncomingUri(uri);
        },
        onError: (err) {
          // Handle deep link error silently
        },
      );
    } catch (e) {
      // Error initializing deep links
    }
  }

  /// Processes an incoming URI from password reset email
  Future<void> _handleIncomingUri(Uri uri) async {
    
    // Handle Firebase Dynamic Links - the actual oobCode is nested in the 'link' parameter
    String? oobCode;
    String? mode;

    // First, try to extract from nested 'link' parameter
    if (uri.queryParameters.containsKey('link')) {
      final linkParam = uri.queryParameters['link'];
      if (linkParam != null) {
        try {
          final nestedUri = Uri.parse(linkParam);
          oobCode = nestedUri.queryParameters['oobCode'];
          mode = nestedUri.queryParameters['mode'];
        } catch (e) {
          // Try direct extraction
          if (linkParam.contains('oobCode=')) {
            final match = RegExp(r'oobCode=([^&]+)').firstMatch(linkParam);
            if (match != null) {
              oobCode = match.group(1);
              mode = 'resetPassword';
            }
          }
        }
      }
    }

    // Fallback to direct parameters
    if (oobCode == null) {
      oobCode = uri.queryParameters['oobCode'];
      mode = uri.queryParameters['mode'];
    }

    if (mode == 'resetPassword' && oobCode != null && oobCode.isNotEmpty) {
      // Valid password reset link - pre-fill the code
      if (mounted) {
        setState(() => _codeController.text = oobCode!);
      }
      
      // Show success message that code was extracted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verification code loaded from email link'),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _handleResetPassword() async {
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate all fields
    final codeError = code.isEmpty ? 'Code is required' : null;
    final passwordError = FormValidators.validatePassword(newPassword);
    final confirmError = confirmPassword != newPassword 
        ? 'Passwords do not match'
        : null;

    if (codeError != null || passwordError != null || confirmError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(codeError ?? passwordError ?? confirmError ?? 'Validation error'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = FirebaseAuthService();

      // Confirm the password reset (also validates the code internally)
      await auth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );

      if (!mounted) return;
      _showSuccessAndNavigate();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'Password reset failed';
      if (e.code == 'invalid-action-code') {
        errorMessage = 'Invalid or expired code. Please try again or request a new reset.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user account has been disabled.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'User not found.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak. Include uppercase, lowercase, numbers, and special characters.';
      } else {
        errorMessage = e.message ?? e.code;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } on TypeError {
      // Known Windows desktop bug: firebase_auth REST API response parsing
      // throws TypeError even though the password reset succeeds.
      if (!mounted) return;
      _showSuccessAndNavigate();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successfully!'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signin,
          (route) => false,
        );
      }
    });
  }

  /// Extract code from manually pasted URL
  void _extractCodeFromPaste() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final pasteController = TextEditingController();
        return AlertDialog(
          title: Text('Paste Email Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paste the full link from your email:',
                style: AppTextStyle.s12,
              ),
              AppGap.h12,
              TextField(
                controller: pasteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'https://quanlythuchiprm.firebaseapp.com/__/auth/...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final url = pasteController.text.trim();
                try {
                  // Try to parse as URI
                  final uri = Uri.parse(url);
                  _handleIncomingUri(uri).then((_) {
                    Navigator.pop(ctx);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid URL: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: Text('Extract'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: AuthAppBar(
            title: 'Reset Password',
            backgroundColor: context.primaryColor,
          ),
          body: _Body(
            codeController: _codeController,
            newPasswordController: _newPasswordController,
            confirmPasswordController: _confirmPasswordController,
            email: _email,
            isLoading: _isLoading,
            onResetPressed: _handleResetPassword,
            onManualPaste: _extractCodeFromPaste,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TextEditingController codeController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final String email;
  final bool isLoading;
  final VoidCallback onResetPressed;
  final VoidCallback? onManualPaste;

  const _Body({
    required this.codeController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.email,
    required this.isLoading,
    required this.onResetPressed,
    this.onManualPaste,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: AppPad.h40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppGap.h24,
            ResetPasswordForm(
              codeController: codeController,
              newPasswordController: newPasswordController,
              confirmPasswordController: confirmPasswordController,
              email: email,
              onManualPaste: onManualPaste,
            ),
            AppGap.h32,
            PrimaryButton(
              text: 'Reset Password',
              onClick: onResetPressed,
              isLoading: isLoading,
            ),
            AppGap.h16,
          ],
        ),
      ),
    );
  }
}
