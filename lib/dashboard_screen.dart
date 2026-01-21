// lib/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transaction_model.dart'; // Import file model vừa tạo

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Format tiền Việt Nam
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      children: [
        // Header Tổng quan
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Text('Số dư hiện tại', style: GoogleFonts.roboto(color: Colors.white70)),
              const SizedBox(height: 5),
              Text(
                '14.500.000 đ',
                style: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderInfo(Icons.arrow_downward, "Thu nhập", "20.000.000", Colors.green[100]!),
                  _buildHeaderInfo(Icons.arrow_upward, "Chi tiêu", "5.500.000", Colors.red[100]!),
                ],
              )
            ],
          ),
        ),
        
        // Danh sách giao dịch
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: mockTransactions.length,
            itemBuilder: (context, index) {
              final item = mockTransactions[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.isExpense ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FaIcon(
                      item.isExpense ? FontAwesomeIcons.bagShopping : FontAwesomeIcons.wallet,
                      color: item.isExpense ? Colors.red : Colors.green,
                      size: 20,
                    ),
                  ),
                  title: Text(item.title, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                  subtitle: Text("${dateFormat.format(item.date)} • ${item.category}"),
                 // Trong file lib/dashboard_screen.dart

trailing: Column(
  mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
  crossAxisAlignment: CrossAxisAlignment.end, // Căn phải
  mainAxisSize: MainAxisSize.min, // QUAN TRỌNG: Chỉ lấy kích thước vừa đủ
  children: [
    Text(
      (item.isExpense ? "- " : "+ ") + currencyFormat.format(item.amount),
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        color: item.isExpense ? Colors.red : Colors.green,
        fontSize: 15,
      ),
    ),
  ],
),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo(IconData icon, String label, String amount, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}