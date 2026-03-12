import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Popup cho Security & Biometrics
/// Tái sử dụng logic từ FirebaseAuthService (forgot password)
class SecurityBiometricsPopup {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Hiển thị popup Security & Biometrics
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _SecurityBiometricsSheet(),
    );
  }

  /// Kiểm tra thiết bị có hỗ trợ biometric không
  static Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  /// Lấy danh sách các loại biometric có sẵn
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Xác thực bằng biometric
  static Future<bool> authenticateBiometric({String reason = 'Authenticate to continue'}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}

class _SecurityBiometricsSheet extends StatefulWidget {
  const _SecurityBiometricsSheet();

  @override
  State<_SecurityBiometricsSheet> createState() => _SecurityBiometricsSheetState();
}

class _SecurityBiometricsSheetState extends State<_SecurityBiometricsSheet> {
  bool _isBiometricEnabled = false;
  bool _isFaceIdEnabled = false;
  bool _isLoading = true;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _loadBiometricSettings();
  }

  Future<void> _loadBiometricSettings() async {
    try {
      final available = await SecurityBiometricsPopup.getAvailableBiometrics();
      if (mounted) {
        setState(() {
          _availableBiometrics = available;
          _isLoading = false;
          // Mặc định tắt, thực tế nên load từ SharedPreferences hoặc Firebase
          _isBiometricEnabled = false;
          _isFaceIdEnabled = available.contains(BiometricType.face);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleBiometricToggle(bool value) async {
    if (value) {
      // Yêu cầu xác thực trước khi bật
      final authenticated = await SecurityBiometricsPopup.authenticateBiometric(
        reason: 'Authenticate to enable fingerprint',
      );
      
      if (authenticated && mounted) {
        setState(() => _isBiometricEnabled = true);
        _showSuccessSnackBar('Fingerprint authentication enabled');
      }
    } else {
      if (mounted) {
        setState(() => _isBiometricEnabled = false);
        _showSuccessSnackBar('Fingerprint authentication disabled');
      }
    }
  }

  Future<void> _handleFaceIdToggle(bool value) async {
    if (value) {
      final authenticated = await SecurityBiometricsPopup.authenticateBiometric(
        reason: 'Authenticate to enable Face ID',
      );
      
      if (authenticated && mounted) {
        setState(() => _isFaceIdEnabled = true);
        _showSuccessSnackBar('Face ID enabled');
      }
    } else {
      if (mounted) {
        setState(() => _isFaceIdEnabled = false);
        _showSuccessSnackBar('Face ID disabled');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: AppPad.h16b24,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: AppPad.h16b24,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: AppPad.h24t20,
              child: Row(
                children: [
                  Container(
                    padding: AppPad.a12,
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: AppBorderRadius.a12,
                    ),
                    child: Icon(
                      Icons.security,
                      color: context.primaryColor,
                      size: 24,
                    ),
                  ),
                  AppGap.w16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security & Biometrics',
                          style: AppTextStyle.s18in.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.primaryTextColor,
                          ),
                        ),
                        AppGap.h4,
                        Text(
                          'Manage security and biometric authentication',
                          style: AppTextStyle.s14in.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Content
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  )
                : Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                      child: Column(
                        children: [
                          // Biometric Authentication Section
                          Padding(
                            padding: AppPad.h24v16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              'BIOMETRIC AUTHENTICATION',
                              style: AppTextStyle.s12in.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.secondaryTextColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            AppGap.h16,

                            // Fingerprint
                            _buildBiometricOption(
                              context: context,
                              icon: Icons.fingerprint,
                              title: 'Fingerprint',
                              subtitle: 'Use fingerprint for quick login',
                              value: _isBiometricEnabled,
                              onChanged: _availableBiometrics.contains(BiometricType.fingerprint)
                                  ? _handleBiometricToggle
                                  : null,
                              isAvailable: _availableBiometrics.contains(BiometricType.fingerprint),
                            ),

                            AppGap.h12,

                            // Face ID
                            _buildBiometricOption(
                              context: context,
                              icon: Icons.face,
                              title: 'Face ID',
                              subtitle: 'Use face for quick login',
                              value: _isFaceIdEnabled,
                              onChanged: _availableBiometrics.contains(BiometricType.face)
                                  ? _handleFaceIdToggle
                                  : null,
                              isAvailable: _availableBiometrics.contains(BiometricType.face),
                            ),

                            if (_availableBiometrics.isEmpty)
                              Padding(
                                padding: AppPad.t24,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: double.infinity),
                                  child: Container(
                                    padding: AppPad.a16,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentYellow.withValues(alpha: 0.1),
                                      borderRadius: AppBorderRadius.a12,
                                      border: Border.all(
                                        color: AppColors.accentYellow.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: AppColors.accentYellow,
                                          size: 20,
                                        ),
                                        AppGap.w12,
                                        Expanded(
                                          child: Text(
                                            'Your device does not support biometric authentication',
                                            style: AppTextStyle.s14in.copyWith(
                                              color: context.primaryTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Password Section
                      Padding(
                        padding: AppPad.h24v16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PASSWORD',
                              style: AppTextStyle.s12in.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.secondaryTextColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            AppGap.h16,

                            // Change Password - Tái sử dụng logic từ forgot password
                            _buildActionTile(
                              context: context,
                              icon: Icons.lock_outline,
                              title: 'Change Password',
                              subtitle: 'Change your account password',
                              onTap: () {
                                Navigator.pop(context);
                                _showChangePasswordDialog(context);
                              },
                            ),

                            AppGap.h12,

                            // Forgot Password - Tái sử dụng từ forgot password flow
                            _buildActionTile(
                              context: context,
                              icon: Icons.password,
                              title: 'Forgot Password',
                              subtitle: 'Reset password via email',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppRoutes.forgotPw);
                              },
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Session Section
                      Padding(
                        padding: AppPad.h24v16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SESSION',
                              style: AppTextStyle.s12in.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.secondaryTextColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            AppGap.h16,

                            _buildActionTile(
                              context: context,
                              icon: Icons.devices,
                              title: 'Device Management',
                              subtitle: 'View and manage logged in devices',
                              onTap: () {
                                Navigator.pop(context);
                                _showDevicesInfo(context);
                              },
                            ),
                          ],
                        ),
                      ),

                      AppGap.h24,
                    ],
                  ),
                  ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required bool isAvailable,
  }) {
    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: AppBorderRadius.a12,
        border: Border.all(
          color: isAvailable ? context.dividerColor : AppColors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: AppPad.a10,
            decoration: BoxDecoration(
              color: isAvailable
                  ? context.primaryColor.withValues(alpha: 0.1)
                  : AppColors.grey.withValues(alpha: 0.1),
              borderRadius: AppBorderRadius.a8,
            ),
            child: Icon(
              icon,
              color: isAvailable ? context.primaryColor : AppColors.grey,
              size: 22,
            ),
          ),
          AppGap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.s15in.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isAvailable ? context.primaryTextColor : AppColors.grey,
                  ),
                ),
                AppGap.h2,
                Text(
                  isAvailable ? subtitle : 'Device not supported',
                  style: AppTextStyle.s13in.copyWith(
                    color: isAvailable ? context.secondaryTextColor : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: context.primaryColor,
            activeTrackColor: context.primaryColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.a12,
      child: Container(
        padding: AppPad.a16,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: AppBorderRadius.a12,
          border: Border.all(color: context.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: AppPad.a10,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppBorderRadius.a8,
              ),
              child: Icon(
                icon,
                color: context.primaryColor,
                size: 22,
              ),
            ),
            AppGap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.s15in.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.primaryTextColor,
                    ),
                  ),
                  AppGap.h2,
                  Text(
                    subtitle,
                    style: AppTextStyle.s13in.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị dialog đổi mật khẩu - tái sử dụng từ forgot password
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.a16,
          ),
          title: Row(
            children: [
              Icon(Icons.lock_reset, color: context.primaryColor),
              AppGap.w12,
              Text(
                'Change Password',
                style: AppTextStyle.s18in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
              ),
              AppGap.h16,
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
              ),
              AppGap.h16,
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a8,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyle.s14in.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      // Validate
                      if (currentPasswordController.text.isEmpty ||
                          newPasswordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        _showErrorSnackBar('Please fill in all fields');
                        return;
                      }

                      if (newPasswordController.text != confirmPasswordController.text) {
                        _showErrorSnackBar('New passwords do not match');
                        return;
                      }

                      if (newPasswordController.text.length < 6) {
                        _showErrorSnackBar('New password must be at least 6 characters');
                        return;
                      }

                      setDialogState(() => _isLoading = true);

                      try {
                        // Tái sử dụng logic từ FirebaseAuthService
                        // Trong thực tế, bạn cần re-authenticate trước khi đổi mật khẩu
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null && user.email != null) {
                          // Re-authenticate
                          final cred = EmailAuthProvider.credential(
                            email: user.email!,
                            password: currentPasswordController.text,
                          );
                          await user.reauthenticateWithCredential(cred);
                          await user.updatePassword(newPasswordController.text);
                          
                          if (context.mounted) {
                            Navigator.pop(context);
                            _showSuccessSnackBar('Password changed successfully!');
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        String message;
                        if (e.code == 'wrong-password') {
                          message = 'Current password is incorrect';
                        } else if (e.code == 'weak-password') {
                          message = 'New password is too weak';
                        } else {
                          message = e.message ?? 'Failed to change password';
                        }
                        _showErrorSnackBar(message);
                      } catch (e) {
                        _showErrorSnackBar('Failed to change password: ${e.toString()}');
                      } finally {
                        if (context.mounted) {
                          setDialogState(() => _isLoading = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.a8,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị thông tin thiết bị
  void _showDevicesInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.a16,
        ),
        title: Row(
          children: [
            Icon(Icons.devices, color: context.primaryColor),
            AppGap.w12,
            Text(
              'Devices',
              style: AppTextStyle.s18in.copyWith(
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppPad.a16,
              decoration: BoxDecoration(
                color: AppColors.incomeGreen.withValues(alpha: 0.1),
                borderRadius: AppBorderRadius.a12,
                border: Border.all(
                  color: AppColors.incomeGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: AppPad.a10,
                    decoration: BoxDecoration(
                      color: AppColors.incomeGreen.withValues(alpha: 0.2),
                      borderRadius: AppBorderRadius.a8,
                    ),
                    child: const Icon(
                      Icons.phone_android,
                      color: AppColors.incomeGreen,
                    ),
                  ),
                  AppGap.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Device',
                          style: AppTextStyle.s15in.copyWith(
                            fontWeight: FontWeight.w500,
                            color: context.primaryTextColor,
                          ),
                        ),
                        AppGap.h2,
                        Text(
                          'Active',
                          style: AppTextStyle.s13in.copyWith(
                            color: AppColors.incomeGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.incomeGreen,
                  ),
                ],
              ),
            ),
            AppGap.h16,
            Text(
              'Device management feature coming soon',
              textAlign: TextAlign.center,
              style: AppTextStyle.s14in.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTextStyle.s14in.copyWith(
                color: context.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
