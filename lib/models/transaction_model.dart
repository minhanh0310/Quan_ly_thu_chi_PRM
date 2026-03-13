import 'package:Quan_ly_thu_chi_PRM/utils/helpers/serialization_helpers.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final String category;
  final String? jarId;
  final String? planId;
  final String? recurringId;
  final String? note;
  final List<String> tags;
  final DateTime date;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
    required this.createdAt,
    this.jarId,
    this.planId,
    this.recurringId,
    this.note,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'isIncome': isIncome,
      'category': category,
      'jarId': jarId,
      'planId': planId,
      'recurringId': recurringId,
      'note': note,
      'tags': tags,
      'date': dateTimeToMillis(date),
      'createdAt': dateTimeToMillis(createdAt),
    };
  }

  factory TransactionModel.fromMap(String id, Map<dynamic, dynamic> map) {
    final rawTags = map['tags'];
    List<String> tags = const [];
    if (rawTags is List) {
      tags = rawTags.map((e) => e.toString()).toList();
    } else if (rawTags is Map) {
      tags = rawTags.values.map((e) => e.toString()).toList();
    }
    return TransactionModel(
      id: id,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      isIncome: map['isIncome'] as bool? ?? false,
      category: map['category'] as String? ?? '',
      jarId: map['jarId'] as String?,
      planId: map['planId'] as String?,
      recurringId: map['recurringId'] as String?,
      note: map['note'] as String?,
      tags: tags,
      date: dateTimeFromMillis(map['date']),
      createdAt: dateTimeFromMillis(map['createdAt']),
    );
  }
}
