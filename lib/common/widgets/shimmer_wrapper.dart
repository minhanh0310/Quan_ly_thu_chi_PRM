import 'package:flutter/widgets.dart';
import 'package:Quan_ly_thu_chi_PRM/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      period: const Duration(milliseconds: 900),
      child: child,
    );
  }
}
