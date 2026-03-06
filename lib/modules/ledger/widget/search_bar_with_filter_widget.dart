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
          child: TextField(
            controller: controller,
            style: AppTextStyle.s14in.copyWith(color: context.primaryTextColor),
            decoration: InputDecoration(
              hintText: hintText ?? 'Search category, tags, notes...',
              hintStyle: AppTextStyle.s14in.copyWith(color: context.hintColor),
              filled: true,
              fillColor: context.inputFillColor,
              prefixIcon: Container(
                padding: AppPad.a12,
                child: SvgPicture.asset(
                  IconPath.search,
                  width: 15,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    context.secondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppBorderRadius.a12,
                borderSide: BorderSide(color: context.borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppBorderRadius.a12,
                borderSide: BorderSide(color: context.primaryColor, width: 1.5),
              ),
              border: OutlineInputBorder(
                borderRadius: AppBorderRadius.a12,
                borderSide: BorderSide(color: context.borderColor, width: 1),
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
              color: context.inputFillColor,
              borderRadius: AppBorderRadius.a12,
              border: Border.all(color: context.borderColor, width: 1),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              IconPath.filter,
              width: 15,
              height: 15,
              colorFilter: ColorFilter.mode(
                context.primaryTextColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
