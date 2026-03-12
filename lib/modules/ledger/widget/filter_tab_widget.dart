import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterTabWidget extends StatefulWidget {
  final Function(int)? onTabChanged;
  final int initialIndex;

  const FilterTabWidget({super.key, this.onTabChanged, this.initialIndex = 0});

  @override
  State<FilterTabWidget> createState() => _FilterTabWidgetState();
}

class _FilterTabWidgetState extends State<FilterTabWidget> {
  late int selectedIndex;

  List<String> get tabs => [
    'ledger_screen.all'.tr(),
    'ledger_screen.income'.tr(),
    'ledger_screen.expense'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(tabs.length, (index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: EdgeInsets.only(right: index < tabs.length - 1 ? 12 : 0),
          child: _buildTab(
            label: tabs[index],
            isSelected: isSelected,
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTabChanged?.call(index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPad.h20v10,
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.1)
              : context.surfaceColor,
          borderRadius: AppBorderRadius.a20,
          border: Border.all(
            color: isSelected ? context.primaryColor : context.borderColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.s14in.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? context.primaryColor
                  : context.secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
