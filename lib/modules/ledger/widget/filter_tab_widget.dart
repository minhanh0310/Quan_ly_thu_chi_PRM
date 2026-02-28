import 'package:Quan_ly_thu_chi_PRM/init.dart';

class FilterTabWidget extends StatefulWidget {
  final Function(int)? onTabChanged;
  final int initialIndex;

  const FilterTabWidget({super.key, this.onTabChanged, this.initialIndex = 0});

  @override
  State<FilterTabWidget> createState() => _FilterTabWidgetState();
}

class _FilterTabWidgetState extends State<FilterTabWidget> {
  late int selectedIndex;

  final List<String> tabs = ['All', 'Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8E7FF) // Light purple
              : AppColors.white,
          borderRadius: AppBorderRadius.a20,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C5CE7) // Purple
                : const Color(0xFFE0E0E0), // Light gray
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.s14in.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF6C5CE7) // Purple
                : AppColors.grey,
          ),
        ),
      ),
    );
  }
}
