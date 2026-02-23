import 'package:Quan_ly_thu_chi_PRM/init.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.onPressed,
    this.backgroundColor = AppColors.mainColor,
    this.boderRadius = BorderRadius.zero,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.borderColor,
  });
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Color backgroundColor;
  final BorderRadiusGeometry boderRadius;
  final Function? onPressed;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed?.call(),
      child: Container(
        padding: padding,
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: boderRadius,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child:
            titleWidget ??
            Text(
              title ?? 'Continue',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  titleStyle ??
                  AppTextStyle.s16in.copyWith(
                    color: AppColors.white,
                  ),
            ),
      ),
    );
  }
}
