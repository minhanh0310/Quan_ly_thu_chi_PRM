import 'package:Quan_ly_thu_chi_PRM/init.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const CustomTextWidget({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style ?? AppTextStyle.s12.copyWith(
        color: AppColors.black,
      ),
    );
  }
}