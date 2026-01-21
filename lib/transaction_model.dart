// lib/transaction_model.dart
class Transaction {
  final String id;
  final String title; // Ví dụ: Ăn trưa
  final String category; // Ví dụ: Ăn uống
  final double amount;
  final DateTime date;
  final bool isExpense; // true = Chi, false = Thu

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
  });
}

// Dữ liệu giả lập để test giao diện
final List<Transaction> mockTransactions = [
  Transaction(id: '1', title: 'Phở bò', category: 'Ăn uống', amount: 55000, date: DateTime.now(), isExpense: true),
  Transaction(id: '2', title: 'Grab đi học', category: 'Di chuyển', amount: 32000, date: DateTime.now(), isExpense: true),
  Transaction(id: '3', title: 'Lương làm thêm', category: 'Lương', amount: 5000000, date: DateTime.now().subtract(const Duration(days: 1)), isExpense: false),
  Transaction(id: '4', title: 'Mua sách Flutter', category: 'Giáo dục', amount: 150000, date: DateTime.now().subtract(const Duration(days: 2)), isExpense: true),
  Transaction(id: '5', title: 'Tiền trợ cấp', category: 'Trợ cấp', amount: 2000000, date: DateTime.now(), isExpense: false),
];