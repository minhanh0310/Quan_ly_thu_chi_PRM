// lib/report_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo tháng này', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Phần biểu đồ tròn
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(color: Colors.redAccent, value: 40, title: '40%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(color: Colors.orange, value: 30, title: '30%', radius: 55, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(color: Colors.blue, value: 15, title: '15%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(color: Colors.green, value: 15, title: '15%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Tổng chi tiêu: 2.300.000 đ", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Chú thích chi tiết
            _buildLegendItem(Colors.redAccent, "Ăn uống", "920.000 đ"),
            _buildLegendItem(Colors.orange, "Di chuyển", "690.000 đ"),
            _buildLegendItem(Colors.blue, "Mua sắm", "345.000 đ"),
            _buildLegendItem(Colors.green, "Khác", "345.000 đ"),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String category, String amount) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: color, radius: 8),
      title: Text(category, style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
      trailing: Text(amount, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
    );
  }
}