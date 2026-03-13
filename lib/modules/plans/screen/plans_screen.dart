import 'package:Quan_ly_thu_chi_PRM/core/widgets/template/function_screen_template.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/widget/savings_goals_tab_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class PlansScreen extends StatelessWidget {
  final VoidCallback? onOpenDrawer;
  const PlansScreen({super.key, this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      backgroundColor: context.backgroundColor,
      onOpenDrawer: onOpenDrawer,
      title: 'plans_screen.title'.tr(),
      subtitle: 'plans_screen.subtitle'.tr(),
      screen: const SavingsGoalsTabWidget(),
    );
  }
}
