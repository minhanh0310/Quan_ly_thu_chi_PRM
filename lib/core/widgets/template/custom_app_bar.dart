import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:stylish_shopping_app/core/extensions/theme_extension.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor:
          backgroundColor ?? AppColors.mainColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: iconColor ?? Colors.white,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Colors.white,
        ),
      ),
      centerTitle: false,
      titleSpacing: 8,
    );
  }
}

// Alternative version with SVG icon support
class CustomAppBarSvg extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? backIconSvgPath;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;

  const CustomAppBarSvg({
    super.key,
    required this.title,
    this.backIconSvgPath,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? const Color(0xFF3629B7),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: AppPad.l24,
        child: IconButton(
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          icon: backIconSvgPath != null
              ? SvgPicture.asset(
                  backIconSvgPath!,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? Colors.white,
                    BlendMode.srcIn,
                  ),
                )
              : SvgPicture.asset(
                  IconPath.arrowLeft,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Colors.white,
        ),
      ),
      centerTitle: false,
      titleSpacing: 8,
    );
  }
}
