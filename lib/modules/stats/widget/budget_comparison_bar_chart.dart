import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/stats/model/stats_model.dart';

/// Bar chart widget comparing Budget vs Actual spending
class BudgetComparisonBarChart extends StatelessWidget {
  final List<MonthlyBudgetData> data;
  final double height;

  const BudgetComparisonBarChart({
    super.key,
    required this.data,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(right: 16, top: 16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: AppColors.raisinBlack,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final isBudget = rodIndex == 0;
                return BarTooltipItem(
                  '${isBudget ? "Budget" : "Actual"}: \$${rod.toY.toStringAsFixed(0)}',
                  AppTextStyle.s12in.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        data[index].month,
                        style: AppTextStyle.s12in.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getMaxY() / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.grey.withValues(alpha: 0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  double _getMaxY() {
    double maxBudget = 0;
    double maxActual = 0;
    for (final item in data) {
      if (item.budget > maxBudget) maxBudget = item.budget;
      if (item.actual > maxActual) maxActual = item.actual;
    }
    final max = maxBudget > maxActual ? maxBudget : maxActual;
    return max * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.budget,
            color: AppColors.primaryPurple,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          BarChartRodData(
            toY: item.actual,
            color: _getColorForStatus(item.status),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
        barsSpace: 8,
      );
    }).toList();
  }

  Color _getColorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return AppColors.green;
      case BudgetStatus.warning:
        return AppColors.accentYellow;
      case BudgetStatus.overSpent:
        return AppColors.expenseRed;
    }
  }
}

/// Legend widget for the bar chart
class BarChartLegend extends StatelessWidget {
  const BarChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Budget', AppColors.primaryPurple),
        AppGap.w20,
        _buildLegendItem('Actual', AppColors.green),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        AppGap.w6,
        Text(
          label,
          style: AppTextStyle.s12in.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
