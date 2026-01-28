import 'package:Quan_ly_thu_chi_PRM/init.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle.s24.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.mainColor,
          ),
        ),

        AppGap.h4,

        Text(
          subtitle,
          style: AppTextStyle.s12.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}
