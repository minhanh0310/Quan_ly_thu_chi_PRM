import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/model/stats_model.dart';

/// Pie chart widget showing expense breakdown by category
class ExpensePieChart extends StatefulWidget {
  final List<CategoryExpense> data;
  final double height;

  const ExpensePieChart({
    super.key,
    required this.data,
    this.height = 250,
  });

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: _buildSections(),
            ),
          ),
        ),
        AppGap.h16,
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = widget.data.fold<double>(0, (sum, item) => sum + item.amount);
    
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final percentage = (item.amount / total) * 100;
      
      return PieChartSectionData(
        color: item.color,
        value: item.amount,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 60 : 50,
        titleStyle: AppTextStyle.s12.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        badgeWidget: isTouched
            ? null
            : null,
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: widget.data.map((item) {
        return _buildLegendItem(
          item.category,
          item.color,
          item.amount,
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color color, double amount) {
    final isSelected = widget.data.indexWhere((e) => e.category == label) == touchedIndex;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          touchedIndex = widget.data.indexWhere((e) => e.category == label);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            AppGap.w6,
            Text(
              label,
              style: AppTextStyle.s12in.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact category breakdown list
class CategoryBreakdownList extends StatelessWidget {
  final List<CategoryExpense> data;

  const CategoryBreakdownList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.amount);
    
    return Column(
      children: data.map((item) {
        final percentage = (item.amount / total) * 100;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCategoryItem(item, percentage),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryItem(CategoryExpense item, double percentage) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: 20,
          ),
        ),
        AppGap.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.category,
                    style: AppTextStyle.s14.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${item.amount.toStringAsFixed(0)}',
                    style: AppTextStyle.s14.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              AppGap.h4,
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: AppColors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(item.color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
