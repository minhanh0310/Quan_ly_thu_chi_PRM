import 'package:Quan_ly_thu_chi_PRM/init.dart';

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
                          // ✅ Divider tự đổi màu theo theme
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h10,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'APPEARANCE'),
                          ),
                          AppGap.h10,

                          _buildDrawerItemWithSwitch(
                            context: context,
                            icon: Icons.dark_mode_outlined,
                            title: 'Dark Mode',
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
                            child: _SectionHeader(title: 'ACCOUNT & SECURITY'),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.settings_outlined,
                            title: 'General Settings',
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Navigate to General Settings screen
                              // Hoặc hiện popup settings
                            },
                          ),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.lock_outline,
                            title: 'Security & Biometrics',
                            onTap: () {
                              Navigator.pop(context);
                              // Hiển popup Security & Biometrics
                              SecurityBiometricsPopup.show(context);
                            },
                          ),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          _buildDrawerItemWithBadge(
                            context: context,
                            icon: Icons.language,
                            title: 'Language',
                            badge: 'EN',
                            badgeColor: const Color(0xFF6C5CE7),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          AppGap.h20,
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'DATA'),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.file_download_outlined,
                            title: 'Export Report (PDF/Excel)',
                            onTap: () => Navigator.pop(context),
                          ),

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.folder_outlined,
                            title: 'Manage Cards & Wallets',
                            onTap: () => Navigator.pop(context),
                          ),

                          AppGap.h20,
                          Divider(height: 1, color: context.dividerColor),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'OTHER'),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            context: context,
                            icon: Icons.help_outline,
                            title: 'Terms of service',
                            onTap: () => Navigator.pop(context),
                          ),

                          _buildDrawerItemLogout(
                            context: context,
                            icon: Icons.logout,
                            title: 'Log out',
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
                        // ✅ Tự đổi theo theme
                        color: context.drawerColor,
                        border: Border(
                          top: BorderSide(
                            color: context.dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'JarsFlow - Expense Management (Build 2026)',
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
                    'Verified Profile',
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

  Widget _buildDrawerItemWithBadge({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String badge,
    required Color badgeColor,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.1),
                borderRadius: AppBorderRadius.a8,
              ),
              child: Text(
                badge,
                style: AppTextStyle.s12in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: badgeColor,
                ),
              ),
            ),
          ],
        ),
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
          'Log out',
          style: TextStyle(color: context.primaryTextColor),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: context.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyle.s14in),
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
              'Log out',
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
