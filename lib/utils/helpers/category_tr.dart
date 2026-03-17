import 'package:easy_localization/easy_localization.dart';

/// Helper extension to translate category keys stored in Firebase.
/// Handles 3 formats:
///   - Translation keys (chuẩn): 'tags.necessities', 'tags.financial_freedom', ...
///   - Special keys: 'PLAN', 'INCOME'
///   - Old data lưu tên tiếng Anh: 'Necessities', 'Financial Freedom', ...
///   - Old data lưu tên tiếng Việt: 'Thiết yếu', 'Tự do tài chính', ...
///
/// Bằng cách map về translation key trước khi dịch,
/// tag sẽ luôn hiển thị đúng ngôn ngữ hiện tại bất kể lưu bằng ngôn ngữ nào.
extension CategoryTr on String {
  String trCategory() {
    // --- Special keys ---
    if (this == 'PLAN') return 'category_labels.plan'.tr();
    if (this == 'INCOME') return 'category_labels.income'.tr();

    // --- Đã là translation key chuẩn ---
    if (startsWith('tags.')) return this.tr();

    // --- Legacy map: tên cũ (EN + VI) → translation key ---
    const legacyMap = {
      // English names
      'necessities': 'tags.necessities',
      'financial freedom': 'tags.financial_freedom',
      'financial_freedom': 'tags.financial_freedom',
      'education': 'tags.education',
      'long-term savings': 'tags.long_term_savings',
      'long_term_savings': 'tags.long_term_savings',
      'entertainment': 'tags.entertainment',
      'give': 'tags.give',
      'income': 'category_labels.income',
      // Vietnamese names
      'thiết yếu': 'tags.necessities',
      'tự do tài chính': 'tags.financial_freedom',
      'giáo dục': 'tags.education',
      'tiết kiệm dài hạn': 'tags.long_term_savings',
      'giải trí': 'tags.entertainment',
      'cho đi': 'tags.give',
      'thu nhập': 'category_labels.income',
      'kế hoạch': 'category_labels.plan',
    };

    final key = legacyMap[toLowerCase()];
    if (key != null) return key.tr();

    // 'Plan: <name>' hoặc 'Kế hoạch: <name>' → dịch prefix, giữ tên plan
    final planPrefixes = ['plan:', 'kế hoạch:'];
    for (final prefix in planPrefixes) {
      if (toLowerCase().startsWith(prefix)) {
        final name = substring(prefix.length).trim();
        return '${'category_labels.plan'.tr()}: $name';
      }
    }

    // Fallback: trả nguyên (user-entered text, tag từ note, ...)
    return this;
  }
}
