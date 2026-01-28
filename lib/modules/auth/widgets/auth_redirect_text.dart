import 'package:Quan_ly_thu_chi_PRM/init.dart';

class AuthRedirectText extends StatelessWidget {
  final String text;
  final String btnText;
  final VoidCallback? onPressed;

  const AuthRedirectText({super.key, required this.text, required this.btnText, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppTextStyle.s12.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),

        TextButton(
          onPressed: onPressed,
          child: Text(
            btnText,
            style: AppTextStyle.s12.copyWith(
              color: AppColors.mainColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
