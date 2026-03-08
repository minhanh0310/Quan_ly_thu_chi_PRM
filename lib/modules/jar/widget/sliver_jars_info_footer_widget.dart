import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverJarsInfoFooterWidget extends StatelessWidget {
  const SliverJarsInfoFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.a10,
      decoration: BoxDecoration(
        color: AppColors.primaryPurpleLight,
        borderRadius: AppBorderRadius.a12,
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryPurple,
            size: 12,
          ),
          AppGap.w5,
          Expanded(
            child: Text(
              'jars_screen.info_footer'.tr(),
              style: AppTextStyle.s12in.copyWith(
                color: AppColors.primaryPurple,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
