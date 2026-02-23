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
  bool isDarkMode = false; // TODO: Get from ThemeProvider

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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value * 300, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 280,
              color: AppColors.white,

              child: Column(
                children: [
                  Expanded(
                    child: SafeArea(
                      bottom: false,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          AppGap.h40,

                          // Close button
                          Padding(
                            padding: AppPad.h20,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffF5F6FA),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          AppGap.h20,

                          // Profile Section
                          Container(
                            padding: AppPad.a20,
                            child: _buildDrawerHeader(),
                          ),

                          AppGap.h10,
                          const Divider(height: 1, color: AppColors.lightGray),
                          AppGap.h10,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'APPEARANCE'),
                          ),
                          AppGap.h10,

                          _buildDrawerItemWithSwitch(
                            icon: Icons.dark_mode_outlined,
                            title: 'Dark Mode',
                            value: isDarkMode,
                            onChanged: (value) {
                              setState(() => isDarkMode = value);
                              print('====> Dark mode: $value');
                            },
                          ),

                          AppGap.h20,
                          const Divider(height: 1, color: AppColors.lightGray),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'ACCOUNT & SECURITY'),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            icon: Icons.settings_outlined,
                            title: 'General Settings',
                            onTap: () {
                              Navigator.pop(context);
                              print('====> Settings');
                            },
                          ),

                          _buildDrawerItem(
                            icon: Icons.lock_outline,
                            title: 'Security & Biometrics',
                            onTap: () {
                              Navigator.pop(context);
                              print('====> Security');
                            },
                          ),

                          _buildDrawerItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            onTap: () {
                              Navigator.pop(context);
                              print('====> Notifications');
                            },
                          ),

                          _buildDrawerItemWithBadge(
                            icon: Icons.language,
                            title: 'Language',
                            badge: 'EN',
                            badgeColor: const Color(0xFF6C5CE7),
                            onTap: () {
                              Navigator.pop(context);
                              print('====> Language');
                            },
                          ),

                          AppGap.h20,
                          const Divider(height: 1, color: AppColors.lightGray),
                          AppGap.h20,

                          Padding(
                            padding: AppPad.h20,
                            child: _SectionHeader(title: 'DATA'),
                          ),
                          AppGap.h10,

                          _buildDrawerItem(
                            icon: Icons.file_download_outlined,
                            title: 'Export Report (PDF/Excel)',
                            onTap: () {
                              Navigator.pop(context);
                              print('====> Export');
                            },
                          ),

                          _buildDrawerItem(
                            icon: Icons.folder_outlined,
                            title: 'Manage Cards & Wallets',
                            onTap: () {
                              Navigator.pop(context);
                              print('====> Wallet');
                            },
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
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        border: Border(
                          top: BorderSide(color: AppColors.lightGray, width: 1),
                        ),
                      ),
                      child: Text(
                        'JarsFlow - Expense Management (Build 2026)',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.s12in.copyWith(
                          color: AppColors.grey,
                          height: 1.5,
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

  Widget _buildDrawerHeader() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6C5CE7),
          ),
          child: const Icon(Icons.person, color: AppColors.white, size: 24),
        ),

        AppGap.w12,

        // Name & Verified
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'mtnee',
                style: AppTextStyle.s16in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    'Verified Profile',
                    style: AppTextStyle.s12in.copyWith(
                      fontSize: 11,
                      color: AppColors.grey,
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

        // Premium Badge
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

  /// Build normal item
  Widget _buildDrawerItem({
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
            Icon(icon, size: 22, color: AppColors.text),
            AppGap.w12,
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  /// Build item with Switch
  Widget _buildDrawerItemWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: AppPad.h20v8,
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.text),
          AppGap.w12,
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.s14in.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF6C5CE7),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Build item with Badge
  Widget _buildDrawerItemWithBadge({
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
            Icon(icon, size: 22, color: AppColors.text),
            AppGap.w12,
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
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
        color: AppColors.grey,
        letterSpacing: 0.5,
      ),
    );
  }
}
