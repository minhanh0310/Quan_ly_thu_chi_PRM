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
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: AppBorderRadius.a12,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: TextField(
              controller: controller,
              style: AppTextStyle.s14in.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                hintText: hintText ?? 'Search category, tags, notes...',
                hintStyle: AppTextStyle.s14in.copyWith(color: AppColors.grey),
                prefixIcon: Container(
                  padding: AppPad.a12,
                  child: SvgPicture.asset(
                    IconPath.search,
                    width: 15,
                    height: 15,
                    colorFilter: const ColorFilter.mode(
                      AppColors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),

        AppGap.w10,

        // Filter button với SvgPicture centered
        GestureDetector(
          onTap:
              onFilterTap ??
              () {
                print('====> Filter tapped');
              },
          child: Container(
            padding: AppPad.a15,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppBorderRadius.a12,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              IconPath.filter,
              width: 15,
              height: 15,
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
