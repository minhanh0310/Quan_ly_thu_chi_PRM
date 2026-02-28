import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SearchBarWithFilterWidget extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final String? hintText;

  const SearchBarWithFilterWidget({
    super.key,
    this.controller,
    this.onFilterTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search TextField
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppBorderRadius.a12,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: TextField(
              controller: controller,
              style: AppTextStyle.s14in.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                hintText: hintText ?? 'Search category, tags, notes...',
                hintStyle: AppTextStyle.s14in.copyWith(color: AppColors.grey),
                prefixIcon: SvgPicture.asset(
                  IconPath.search,
                  colorFilter: ColorFilter.mode(
                    AppColors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 12,
                  width: 12,
                ),
                border: InputBorder.none,
                contentPadding: AppPad.h16v14,
              ),
            ),
          ),
        ),

        AppGap.w10,

        // Filter button
        GestureDetector(
          onTap:
              onFilterTap ??
              () {
                print('====> Filter tapped');
              },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppBorderRadius.a12,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: SvgPicture.asset(IconPath.filter, height: 20, width: 20),
          ),
        ),
      ],
    );
  }
}
