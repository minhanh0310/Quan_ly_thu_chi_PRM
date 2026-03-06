import 'package:Quan_ly_thu_chi_PRM/init.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;

  final VoidCallback? onOpenDrawer;

  const CustomAppBar({super.key, this.title, this.subtitle, this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.appBarColor,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      titleSpacing: 0,

      leading: Padding(
        padding: AppPad.l16,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.surfaceVariant,
          ),
          child: IconButton(
            onPressed: onOpenDrawer,
            icon: Icon(Icons.menu, color: context.primaryTextColor, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ),

      title: Padding(
        padding: AppPad.l10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? 'JarsFlow',
              style: AppTextStyle.s20in.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            AppGap.h5,
            Text(
              subtitle ?? 'MODERN WEALTH',
              style: AppTextStyle.s12in.copyWith(
                color: AppColors.grey,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
