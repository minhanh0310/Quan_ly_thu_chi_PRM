import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cài đặt & Khác'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Phần thông tin cá nhân
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: Text("TA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tuấn / Minh Anh", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text("Nhóm trưởng Project", style: GoogleFonts.roboto(color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Các mục cài đặt
          _buildSectionHeader("CÀI ĐẶT CHUNG"),
          _buildSettingsItem(Icons.category, "Quản lý danh mục", null),
          _buildSettingsItem(Icons.notifications, "Nhắc nhở nhập liệu", Switch(value: true, onChanged: (val){}, activeColor: Colors.orange)),
          _buildSettingsItem(Icons.currency_exchange, "Đơn vị tiền tệ", const Text("VND", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          
          const SizedBox(height: 20),
          _buildSectionHeader("DỮ LIỆU & BẢO MẬT"),
          _buildSettingsItem(Icons.cloud_upload, "Sao lưu dữ liệu", null),
          _buildSettingsItem(Icons.lock, "Đặt mã khóa app", null),

          const SizedBox(height: 20),
          _buildSectionHeader("THÔNG TIN"),
          _buildSettingsItem(Icons.info, "Về ứng dụng", null),
          _buildSettingsItem(Icons.group, "Thành viên nhóm", null),
          
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: const Text("Đăng xuất"),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text(title, style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, Widget? trailing) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1), // Tạo đường kẻ mờ
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(title, style: GoogleFonts.roboto()),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}