import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/widget/sliver_jar_card_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class SliverJarsListWidget extends StatelessWidget {
  const SliverJarsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FinanceDatabaseService();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'jars_screen.current_distribution'.tr()),
        AppGap.h16,
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            final uid = authSnapshot.data?.uid;
            if (uid == null) {
              return const SizedBox.shrink();
            }
            return FutureBuilder<void>(
              future: service.ensureDefaultJars(uid),
              builder: (context, snapshot) {
                return StreamBuilder<List<JarModel>>(
                  stream: service.watchJars(uid),
                  builder: (context, snap) {
                    final jars = snap.data ?? const [];
                    if (jars.isEmpty) {
                      return Text(
                        'No jars yet',
                        style: AppTextStyle.s12in.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      );
                    }
                    return Column(
                      children: jars
                          .map((jar) => SliverJarCardWidget(jar: jar))
                          .toList(),
                    );
                  },
                );
              },
            );
          },
        ),
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
