import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jar_card_widget.dart';

class SliverJarsListWidget extends StatelessWidget {
  const SliverJarsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Current Distribution'),
        AppGap.h16,

        ...JarModel.mockList.map((jar) => SliverJarCardWidget(jar: jar)),
      ],
    );
  }
}


class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.s16in.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryTextColor,
          ),
        ),
        if (trailing != null) GestureDetector(onTap: onTap, child: trailing!),
      ],
    );
  }
}

class _SectionHeader extends SectionHeader {
  const _SectionHeader({required super.title});
}
