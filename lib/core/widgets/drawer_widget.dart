import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isLanguageExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value * 300, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 280,
              color: context.drawerColor,
              child: Column(
                children: [
                  Expanded(
                    child: SafeArea(
                      bottom: false,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          AppGap.h20,

                          // Profile Section
                          Container(
                            padding: AppPad.a20,
                            child: _buildDrawerHeader(context),
                          ),

                          AppGap.h10,
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h10,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(
                              title: 'drawer.appearance'.tr(),
                            ),
                          ),
                          AppGap.h10,

                          _buildDrawerItemWithSwitch(
                            context: context,
                            icon: Icons.dark_mode_outlined,
                            title: 'drawer.dark_mode'.tr(),
                            value: themeProvider.isDarkMode,
                            onChanged: (value) {
                              context.read<ThemeProvider>().setDarkMode(value);
                            },
                          ),

                          AppGap.h20,
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(
                              title: 'drawer.account_security'.tr(),
                            ),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.settings_outlined,
                            title: 'drawer.general_settings'.tr(),
                            onTap: () => Navigator.pop(context),
                          ),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.lock_outline,
                            title: 'drawer.security_biometrics'.tr(),
                            onTap: () => Navigator.pop(context),
                          ),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.notifications_outlined,
                            title: 'drawer.notifications'.tr(),
                            onTap: () => Navigator.pop(context),
                          ),

                          // ── Language expand ──
                          _buildLanguageExpand(context),

                          AppGap.h20,
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'drawer.data'.tr()),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.file_download_outlined,
                            title: 'drawer.export_report'.tr(),
                            onTap: () => Navigator.pop(context),
                          ),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.folder_outlined,
                            title: 'drawer.manage_wallets'.tr(),
                            onTap: () => Navigator.pop(context),
                          ),

                          AppGap.h20,
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'drawer.other'.tr()),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.help_outline,
                            title: 'drawer.terms_of_service'.tr(),
                            onTap: () => Navigator.pop(context),
                          ),

                          _buildDrawerItemLogout(
                            context: context,
                            icon: Icons.logout,
                            title: 'drawer.logout'.tr(),
                            onTap: () => _showLogoutDialog(context),
                          ),

                          AppGap.h40,
                        ],
                      ),
                    ),
                  ),

                  SafeArea(
                    top: false,
                    child: Container(
                      padding: AppPad.a20,
                      decoration: BoxDecoration(
                        color: context.drawerColor,
                        border: Border(
                          top: BorderSide(
                            color: context.dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'drawer.footer'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.s12in.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Language expand widget ──
  Widget _buildLanguageExpand(BuildContext context) {
    final languages = [
      {'label': 'English', 'locale': const Locale('en', 'US'), 'badge': 'EN'},
      {
        'label': 'Tiếng Việt',
        'locale': const Locale('vi', 'VN'),
        'badge': 'VI',
      },
    ];

    final currentCode = context.locale.languageCode;

    return Column(
      children: [
        // Header row
        InkWell(
          onTap: () =>
              setState(() => _isLanguageExpanded = !_isLanguageExpanded),
          child: Padding(
            padding: AppPad.h20v12,
            child: Row(
              children: [
                Icon(Icons.language, size: 22, color: context.iconColor),
                AppGap.w12,
                Expanded(
                  child: Text(
                    'drawer.language'.tr(),
                    style: AppTextStyle.s14in.copyWith(
                      fontWeight: FontWeight.w500,
                      color: context.primaryTextColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                    borderRadius: AppBorderRadius.a8,
                  ),
                  child: Text(
                    currentCode == 'vi' ? 'VI' : 'EN',
                    style: AppTextStyle.s12in.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C5CE7),
                    ),
                  ),
                ),
                AppGap.w8,
                Icon(
                  _isLanguageExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: context.secondaryTextColor,
                ),
              ],
            ),
          ),
        ),

        // Expand options
        if (_isLanguageExpanded)
          ...languages.map((lang) {
            final locale = lang['locale'] as Locale;
            final isSelected = context.locale == locale;
            return InkWell(
              onTap: () {
                context.setLocale(locale);
                setState(() => _isLanguageExpanded = false);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 54,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lang['label'] as String,
                        style: AppTextStyle.s14in.copyWith(
                          color: isSelected
                              ? context.primaryColor
                              : context.primaryTextColor,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: context.primaryColor,
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: context.primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: context.primaryColor, size: 28),
        ),
        AppGap.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'mtnee',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryTextColor,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    'drawer.verified_profile'.tr(),
                    style: AppTextStyle.s12in.copyWith(
                      fontSize: 11,
                      color: context.secondaryTextColor,
                    ),
                  ),
                  AppGap.w4,
                  const Icon(
                    Icons.verified,
                    size: 14,
                    color: Color(0xFF00D09E),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EDFF),
            borderRadius: AppBorderRadius.a12,
          ),
          child: Text(
            'PREMIUM',
            style: AppTextStyle.s12in.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6C5CE7),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppPad.h20v12,
        child: Row(
          children: [
            Icon(icon, size: 22, color: context.iconColor),
            AppGap.w12,
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.primaryTextColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: context.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItemWithSwitch({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: AppPad.h20v8,
      child: Row(
        children: [
          Icon(icon, size: 22, color: context.iconColor),
          AppGap.w12,
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.s14in.copyWith(
                fontWeight: FontWeight.w500,
                color: context.primaryTextColor,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: context.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItemLogout({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppPad.h20v12,
        child: Row(
          children: [
            Icon(icon, size: 22, color: context.errorColor),
            AppGap.w12,
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'drawer.logout_title'.tr(),
          style: TextStyle(color: context.primaryTextColor),
        ),
        content: Text(
          'drawer.logout_message'.tr(),
          style: TextStyle(color: context.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('drawer.logout_cancel'.tr(), style: AppTextStyle.s14in),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close drawer
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signin,
                (route) => false,
              );
            },
            child: Text(
              'drawer.logout_confirm'.tr(),
              style: AppTextStyle.s14in.copyWith(
                color: context.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Section Header
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.s12in.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: context.secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
