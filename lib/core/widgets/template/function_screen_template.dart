import 'package:flutter/material.dart';


class FunctionScreenTemplate extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool showMenuIcon; // true = menu, false = back
  final bool showNotification;
  final bool showAvatar;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onAvatarPressed;

  const FunctionScreenTemplate({
    super.key,
    this.title = 'JarsFlow',
    this.subtitle = 'MODERN WEALTH',
    this.showMenuIcon = false,
    this.showNotification = true,
    this.showAvatar = true,
    this.onMenuPressed,
    this.onBackPressed,
    this.onNotificationPressed,
    this.onAvatarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // TODO: Thay bằng theme color
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      titleSpacing: 0,

      // Leading: Menu hoặc Back
      leading: showMenuIcon
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black87, size: 24),
                onPressed:
                    onMenuPressed ??
                    () {
                      Scaffold.of(context).openDrawer();
                    },
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                  size: 24,
                ),
                onPressed:
                    onBackPressed ??
                    () {
                      Navigator.of(context).maybePop();
                    },
              ),
            ),

      // Title
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B4CFE),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
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

      // Actions
      actions: [
        // Notification
        if (showNotification)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black87,
                size: 24,
              ),
              onPressed:
                  onNotificationPressed ??
                  () {
                    print('====> Notification pressed');
                  },
            ),
          ),

        // Avatar
        if (showAvatar)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap:
                  onAvatarPressed ??
                  () {
                    print('====> Avatar pressed');
                  },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600], size: 24),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
