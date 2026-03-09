import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/services/firebase_auth_service.dart';
import 'package:Quan_ly_thu_chi_PRM/services/user_database_service.dart';
import 'package:easy_localization/easy_localization.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final _authService = FirebaseAuthService();
  final _userDbService = UserDatabaseService();
  late TextEditingController _nameController;
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser;
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? '';
    _nameController = TextEditingController(text: displayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = 'validation.name_required'.tr();
      });
      return;
    }
    final user = _authService.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // First check if user record exists in database
      final userRecord = await _userDbService.getUserById(user.uid);
      if (userRecord == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorText = 'User profile not found. Please try again.';
        });
        return;
      }

      // Update Firebase Auth display name
      await _authService.updateDisplayName(name);
      
      // Then update database with complete user data to prevent data loss
      await _userDbService.updateUserName(user.uid, name);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('success.operation_completed'.tr()),
          backgroundColor: AppColors.incomeGreen,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorText = e.toString().contains('User record not found')
            ? 'User profile not found. Please sign in again.'
            : 'errors.operation_failed'.tr();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final email = user?.email ?? '';
    final photoUrl = user?.photoURL;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.appBarColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 20, color: context.primaryTextColor),
          ),
          title: Text(
            'drawer.general_settings'.tr(),
            style: AppTextStyle.s20in.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: AppPad.a20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppGap.h24,
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? Icon(Icons.person, size: 48, color: context.primaryColor)
                      : null,
                ),
              ),
              AppGap.h32,
              Text(
                'common.edit'.tr(),
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.secondaryTextColor,
                ),
              ),
              AppGap.h8,
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'sign_up.full_name'.tr(),
                  hintText: 'sign_up.full_name'.tr(),
                  errorText: _errorText,
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.a12,
                  ),
                  filled: true,
                  fillColor: context.surfaceVariant.withValues(alpha: 0.3),
                ),
                onChanged: (_) => setState(() => _errorText = null),
              ),
              AppGap.h16,
              Text(
                'sign_up.email'.tr(),
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.secondaryTextColor,
                ),
              ),
              AppGap.h8,
              Container(
                padding: AppPad.h16v14,
                decoration: BoxDecoration(
                  color: context.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: AppBorderRadius.a12,
                  border: Border.all(
                    color: context.dividerColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  email,
                  style: AppTextStyle.s16in.copyWith(
                    color: context.primaryTextColor,
                  ),
                ),
              ),
              AppGap.h8,
              Text(
                'drawer.verified_profile'.tr(),
                style: AppTextStyle.s12in.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
              AppGap.h40,
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.a12,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          'common.save'.tr(),
                          style: AppTextStyle.s16in.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
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
