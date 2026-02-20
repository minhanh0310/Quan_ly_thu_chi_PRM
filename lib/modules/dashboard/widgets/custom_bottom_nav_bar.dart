import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/dashboard/model/bottom_nav_item.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
// TODO: Import đúng path của AppTextStyle trong project
// import 'package:Quan_ly_thu_chi_PRM/core/theme/app_text_style.dart';

/// Widget Bottom Navigation Bar tùy chỉnh
/// Hiển thị text khi selected, icon khi unselected
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors
            .white, // TODO: Thay bằng context.secondaryColor từ theme extension
        boxShadow: [
          BoxShadow(
            color: const Color(0x1D1E2014),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff9775FA),
        unselectedItemColor: const Color(0xff8F959E),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: items.asMap().entries.map((entry) {
          return _buildNavItem(
            entry.key,
            entry.value.label,
            entry.value.iconPath,
          );
        }).toList(),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    int index,
    String label,
    String iconPath,
  ) {
    final isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: isSelected
          ? Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff9775FA),
                fontWeight: FontWeight.w500,
              ), // TODO: Thay bằng AppTextStyle.s11 từ theme
            )
          : SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xff8F959E),
                BlendMode.srcIn,
              ),
            ),
      label: '',
    );
  }
}
