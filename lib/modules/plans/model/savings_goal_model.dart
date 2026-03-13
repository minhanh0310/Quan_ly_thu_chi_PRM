import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/serialization_helpers.dart';

enum SavingsGoalStatus { active, completed, overdue }

/// One entry in accumulation history (lịch sử tích lũy)
class AccumulationEntry {
  final DateTime date;
  final String title;       // e.g. "Tiết kiệm tháng 2/2026"
  final String subtitle;   // e.g. "Chuyển từ tài khoản lương"
  final double amount;
  final String? id;

  const AccumulationEntry({
    this.id,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': dateTimeToMillis(date),
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
    };
  }

  factory AccumulationEntry.fromMap(String id, Map<dynamic, dynamic> map) {
    return AccumulationEntry(
      id: id,
      date: dateTimeFromMillis(map['date']),
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Milestone for roadmap display
class PlanMilestone {
  final String title;
  final String description;
  final DateTime? date;
  final bool isReached;
  final String? id;

  const PlanMilestone({
    this.id,
    required this.title,
    required this.description,
    this.date,
    this.isReached = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date != null ? dateTimeToMillis(date!) : null,
      'isReached': isReached,
    };
  }

  factory PlanMilestone.fromMap(String id, Map<dynamic, dynamic> map) {
    return PlanMilestone(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] != null ? dateTimeFromMillis(map['date']) : null,
      isReached: map['isReached'] as bool? ?? false,
    );
  }
}

class SavingsGoalModel {
  final String id;
  final String name;
  final String? description;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String? imageUrl;
  final Color color;
  final IconData icon;
  final DateTime createdAt;
  /// Links plan to a jar (e.g. "financial_freedom"). Add money comes from this jar.
  final String? jarId;
  final List<PlanMilestone>? milestones;
  /// Lịch sử tích lũy — past contributions to this plan
  final List<AccumulationEntry> accumulationHistory;

  const SavingsGoalModel({
    required this.id,
    required this.name,
    this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    this.imageUrl,
    required this.color,
    required this.icon,
    required this.createdAt,
    this.jarId,
    this.milestones,
    List<AccumulationEntry>? accumulationHistory,
  }) : accumulationHistory = accumulationHistory ?? const [];

  SavingsGoalModel copyWith({
    String? id,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? imageUrl,
    Color? color,
    IconData? icon,
    DateTime? createdAt,
    String? jarId,
    List<PlanMilestone>? milestones,
    List<AccumulationEntry>? accumulationHistory,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      jarId: jarId ?? this.jarId,
      milestones: milestones ?? this.milestones,
      accumulationHistory: accumulationHistory ?? this.accumulationHistory,
    );
  }

  double get progressPercent => 
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0;
  
  bool get isCompleted => currentAmount >= targetAmount;
  
  bool get isOverdue => DateTime.now().isAfter(deadline) && !isCompleted;
  
  SavingsGoalStatus get status {
    if (isCompleted) return SavingsGoalStatus.completed;
    if (isOverdue) return SavingsGoalStatus.overdue;
    return SavingsGoalStatus.active;
  }

  double get monthlyRequired {
    final now = DateTime.now();
    final monthsRemaining = deadline.difference(now).inDays / 30;
    if (monthsRemaining <= 0) return targetAmount - currentAmount;
    return (targetAmount - currentAmount) / monthsRemaining;
  }

  double get remainingAmount => targetAmount - currentAmount;

  /// Jar id for Financial Freedom — plans use this jar as source when adding money.
  static const String jarFinancialFreedom = 'financial_freedom';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': dateTimeToMillis(deadline),
      'imageUrl': imageUrl,
      'color': colorToValue(color),
      'icon': iconDataToMap(icon),
      'createdAt': dateTimeToMillis(createdAt),
      'jarId': jarId,
      'milestones': milestones?.map((m) => m.toMap()).toList(),
      'accumulationHistory': accumulationHistory.map((e) => e.toMap()).toList(),
    };
  }

  factory SavingsGoalModel.fromMap(String id, Map<dynamic, dynamic> map) {
    final rawMilestones = map['milestones'];
    final rawHistory = map['accumulationHistory'];
    final milestonesList = <PlanMilestone>[];
    if (rawMilestones is List) {
      for (int i = 0; i < rawMilestones.length; i++) {
        final item = rawMilestones[i];
        if (item is Map) {
          milestonesList.add(PlanMilestone.fromMap(i.toString(), item));
        }
      }
    } else if (rawMilestones is Map) {
      rawMilestones.forEach((key, value) {
        if (value is Map) {
          milestonesList.add(PlanMilestone.fromMap(key.toString(), value));
        }
      });
    }

    final historyList = <AccumulationEntry>[];
    if (rawHistory is List) {
      for (int i = 0; i < rawHistory.length; i++) {
        final item = rawHistory[i];
        if (item is Map) {
          historyList.add(AccumulationEntry.fromMap(i.toString(), item));
        }
      }
    } else if (rawHistory is Map) {
      rawHistory.forEach((key, value) {
        if (value is Map) {
          historyList.add(AccumulationEntry.fromMap(key.toString(), value));
        }
      });
    }
    return SavingsGoalModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String?,
      targetAmount: (map['targetAmount'] as num?)?.toDouble() ?? 0,
      currentAmount: (map['currentAmount'] as num?)?.toDouble() ?? 0,
      deadline: dateTimeFromMillis(map['deadline']),
      imageUrl: map['imageUrl'] as String?,
      color: colorFromValue((map['color'] as num?)?.toInt() ?? 0xFF6C5CE7),
      icon: map['icon'] is Map
          ? iconDataFromMap(map['icon'] as Map<dynamic, dynamic>)
          : Icons.flag_rounded,
      createdAt: dateTimeFromMillis(map['createdAt']),
      jarId: map['jarId'] as String?,
      milestones: milestonesList.isEmpty ? null : milestonesList,
      accumulationHistory: historyList,
    );
  }
}
