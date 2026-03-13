import 'package:flutter/foundation.dart';
import 'package:Quan_ly_thu_chi_PRM/services/user_database_service.dart';

/// Quản lý đơn vị tiền tệ của người dùng.
/// Currency được chọn trong onboarding và không thể thay đổi sau đó.
class CurrencyProvider extends ChangeNotifier {
  String _currency = 'VND';
  bool _isLoaded = false;

  String get currency => _currency;
  bool get isLoaded => _isLoaded;
  bool get isVND => _currency == 'VND';
  String get symbol => isVND ? '₫' : '\$';

  /// Gọi sau khi user chọn xong onboarding
  void setCurrency(String currency) {
    _currency = currency;
    _isLoaded = true;
    notifyListeners();
  }

  /// Gọi khi user đã có currency lưu sẵn trên Firebase (returning user)
  Future<void> loadFromFirebase(String uid) async {
    try {
      final user = await UserDatabaseService().getUserById(uid);
      final saved = user?.currency;
      if (saved != null && saved.isNotEmpty) {
        _currency = saved;
        _isLoaded = true;
        notifyListeners();
      }
    } catch (_) {
      // Silent fail – giữ nguyên giá trị mặc định
    }
  }

  // ── Format helpers ───────────────────────────────────────────────────────

  /// Format số tiền theo đơn vị đã chọn — hiển thị số thực tế, không viết tắt.
  /// VND: `30,000,000 ₫`
  /// USD: `$ 1,200.50`
  String formatCurrency(double amount) {
    return isVND ? _formatVND(amount) : _formatUSD(amount);
  }

  /// Trả về prefix text để dùng trong TextField (vd: "VND " hoặc "$ ")
  String get inputPrefix => isVND ? 'VND ' : '\$ ';

  String _formatVND(double amount) {
    final parts = amount.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    final len = parts.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write(',');
      buffer.write(parts[i]);
    }
    return '${buffer.toString()} ₫';
  }

  String _formatUSD(double amount) {
    final intPart = amount.truncate();
    final decPart = ((amount - intPart) * 100).round();
    final parts = intPart.toString().split('');
    final buffer = StringBuffer();
    final len = parts.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write(',');
      buffer.write(parts[i]);
    }
    return '\$ ${buffer.toString()}.${decPart.toString().padLeft(2, '0')}';
  }
}
