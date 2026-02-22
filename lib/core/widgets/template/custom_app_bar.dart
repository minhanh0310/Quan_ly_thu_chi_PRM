import 'package:Quan_ly_thu_chi_PRM/init.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentTabIndex;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onAvatarPressed;

  final String? customTitle;
  final String? customSubtitle;
  final bool showNotification;
  final bool showAvatar;

  const CustomAppBar({
    super.key,
    required this.currentTabIndex,
    this.onNotificationPressed,
    this.onAvatarPressed,
    this.customTitle,
    this.customSubtitle,
    this.showNotification = true,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      titleSpacing: 0,

      // Title: App name + subtitle
      title: Padding(
        padding: AppPad.l20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              customTitle ?? _getTabTitle(currentTabIndex),
              style: AppTextStyle.s20in.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary
              ),
              // style: const TextStyle(
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              //   color: Color(0xFF5B4CFE),
              //   letterSpacing: -0.5,
              // ),
            ),
            AppGap.h5,
            Text(
              customSubtitle ?? _getTabSubtitle(currentTabIndex),
              style: AppTextStyle.s12in.copyWith(
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),

      // Actions: Notification + Avatar
      actions: [
        // Notification Icon
        if (showNotification)
          Padding(
            padding: AppPad.r10,
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed:
                      onNotificationPressed ??
                      () {
                        // TODO: Navigate to notifications
                        print('====> Notification pressed');
                      },
                ),
                // TODO: Uncomment để hiện badge số lượng notification
                // Positioned(
                //   right: 8,
                //   top: 8,
                //   child: Container(
                //     padding: const EdgeInsets.all(4),
                //     decoration: const BoxDecoration(
                //       color: Color(0xFFFF6B93),
                //       shape: BoxShape.circle,
                //     ),
                //     constraints: const BoxConstraints(
                //       minWidth: 16,
                //       minHeight: 16,
                //     ),
                //     child: const Text(
                //       '3', // TODO: Bind với số notification thật
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 10,
                //         fontWeight: FontWeight.bold,
                //       ),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

        // User Avatar
        if (showAvatar)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap:
                  onAvatarPressed ??
                  () {
                    // TODO: Navigate to profile or show menu
                    print('====> Avatar pressed');
                  },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                // TODO: Load user avatar từ state/API
                backgroundImage: null, // NetworkImage(userAvatarUrl)
                child: Icon(Icons.person, color: Colors.grey[600], size: 24),
              ),
            ),
          ),
      ],
    );
  }

  /// Get title dựa vào tab index
  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'JarsFlow';
      case 1:
        return 'Ledger';
      case 2:
        return 'My Plans';
      case 3:
        return 'Statistics';
      default:
        return 'JarsFlow';
    }
  }

  /// Get subtitle dựa vào tab index
  String _getTabSubtitle(int index) {
    switch (index) {
      case 0:
        return 'MODERN WEALTH';
      case 1:
        return 'TRANSACTION HISTORY';
      case 2:
        return 'SAVING GOALS';
      case 3:
        return 'FINANCIAL INSIGHTS';
      default:
        return 'MODERN WEALTH';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class CustomAppBarWithSettings extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onSettingsPressed;

  const CustomAppBarWithSettings({super.key, this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      titleSpacing: 0,

      title: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'JarsFlow',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B4CFE),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Modern Wealth Manager',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.grey[700],
                size: 22,
              ),
              onPressed:
                  onSettingsPressed ??
                  () {
                    // TODO: Navigate to settings
                    print('====> Settings pressed');
                  },
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
