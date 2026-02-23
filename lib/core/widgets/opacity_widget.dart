import 'dart:ui';

import 'package:Quan_ly_thu_chi_PRM/init.dart';

class OpacityWidget extends StatelessWidget {
  const OpacityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        color: AppColors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
