import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  bool _isExpense = true; // Mặc định là Khoản Chi
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = "Ăn uống"; // Mặc định

  // Danh sách danh mục giả định
  final List<String> _categories = ["Ăn uống", "Di chuyển", "Mua sắm", "Giải trí", "Lương", "Thưởng", "Khác"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm giao dịch mới"),
        backgroundColor: _isExpense ? Colors.redAccent : Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Chọn Thu hay Chi
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isExpense = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isExpense ? Colors.redAccent : Colors.grey[200],
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                      ),
                      alignment: Alignment.center,
                      child: Text("CHI TIÊU", 
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold, 
                          color: _isExpense ? Colors.white : Colors.black54
                        )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isExpense = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isExpense ? Colors.green : Colors.grey[200],
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                      ),
                      alignment: Alignment.center,
                      child: Text("THU NHẬP", 
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold, 
                          color: !_isExpense ? Colors.white : Colors.black54
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 2. Nhập số tiền
            Text("Số tiền", style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: _isExpense ? Colors.red : Colors.green),
              decoration: InputDecoration(
                hintText: "0",
                suffixText: "đ",
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _isExpense ? Colors.red : Colors.green)),
              ),
            ),
            const SizedBox(height: 25),

            // 3. Chọn Danh mục & Ngày
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Danh mục", style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey)),
                      DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        underline: Container(height: 1, color: Colors.grey[300]),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                        items: _categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ngày", style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey)),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // 4. Ghi chú
            Text("Ghi chú", style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey)),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: "Ví dụ: Ăn trưa cùng đồng nghiệp",
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
              ),
            ),
            const SizedBox(height: 40),

            // 5. Nút Lưu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Sau này sẽ code logic lưu vào Database ở đây
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã lưu giao dịch (Demo)')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isExpense ? Colors.redAccent : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("LƯU GIAO DỊCH", style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị lịch chọn ngày
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _isExpense ? Colors.redAccent : Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}