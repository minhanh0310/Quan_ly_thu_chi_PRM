import 'package:flutter/material.dart';

enum SavingsGoalStatus { active, completed, overdue }

/// One entry in accumulation history (lịch sử tích lũy)
class AccumulationEntry {
  final DateTime date;
  final String title;       // e.g. "Tiết kiệm tháng 2/2026"
  final String subtitle;   // e.g. "Chuyển từ tài khoản lương"
  final double amount;

  const AccumulationEntry({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
  });
}

/// Milestone for roadmap display
class PlanMilestone {
  final String title;
  final String description;
  final DateTime? date;
  final bool isReached;

  const PlanMilestone({
    required this.title,
    required this.description,
    this.date,
    this.isReached = false,
  });
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

  static List<SavingsGoalModel> get mockList => [
    SavingsGoalModel(
      id: '1',
      name: 'Buy iPhone 16 Pro',
      description: 'New phone for work',
      targetAmount: 30000000,
      currentAmount: 15000000,
      deadline: DateTime(2026, 6, 1),
      color: const Color(0xFF6C5CE7),
      icon: Icons.phone_iphone_rounded,
      createdAt: DateTime(2025, 12, 1),
      jarId: jarFinancialFreedom,
    ),
    SavingsGoalModel(
      id: '2',
      name: 'Japan Trip',
      description: 'Summer vacation 2026',
      targetAmount: 50000000,
      currentAmount: 20000000,
      deadline: DateTime(2026, 7, 15),
      color: const Color(0xFFFF6B93),
      icon: Icons.flight_rounded,
      createdAt: DateTime(2025, 10, 1),
      jarId: jarFinancialFreedom,
    ),
    SavingsGoalModel(
      id: '3',
      name: 'Emergency Fund',
      description: '3 months expenses',
      targetAmount: 50000000,
      currentAmount: 45000000,
      deadline: DateTime(2026, 3, 31),
      color: const Color(0xFF00D09E),
      icon: Icons.savings_rounded,
      createdAt: DateTime(2025, 6, 1),
      jarId: jarFinancialFreedom,
    ),
    SavingsGoalModel(
      id: '4',
      name: 'Buy a House',
      description: 'First home',
      targetAmount: 500000000,
      currentAmount: 125000000,
      deadline: DateTime(2030, 12, 31),
      color: const Color(0xFF5B4EFF),
      icon: Icons.home_rounded,
      createdAt: DateTime(2025, 1, 1),
      jarId: jarFinancialFreedom,
      milestones: [
        PlanMilestone(
          title: 'Started Saving',
          description: 'Initial commitment made',
          date: DateTime(2025, 1, 1),
          isReached: true,
        ),
        PlanMilestone(
          title: '25% Milestone',
          description: 'Quarter-way to the dream',
          date: DateTime(2026, 9, 1),
          isReached: true,
        ),
        PlanMilestone(
          title: 'Goal Reached',
          description: 'Final acquisition phase',
          date: DateTime(2030, 12, 31),
          isReached: false,
        ),
      ],
      accumulationHistory: [
        AccumulationEntry(
          date: DateTime(2026, 2, 1),
          title: 'Tiết kiệm tháng 2/2026',
          subtitle: 'Chuyển từ tài khoản lương',
          amount: 2500000,
        ),
        AccumulationEntry(
          date: DateTime(2026, 1, 1),
          title: 'Tiết kiệm tháng 1/2026',
          subtitle: 'Chuyển từ tài khoản lương',
          amount: 2500000,
        ),
        AccumulationEntry(
          date: DateTime(2025, 12, 1),
          title: 'Tiết kiệm tháng 12/2025',
          subtitle: 'Chuyển từ tài khoản lương',
          amount: 2500000,
        ),
      ],
    ),
    SavingsGoalModel(
      id: '5',
      name: 'Old Goal - Overdue',
      targetAmount: 10000000,
      currentAmount: 3000000,
      deadline: DateTime(2025, 12, 31),
      color: const Color(0xFFFFC94D),
      icon: Icons.flag_rounded,
      createdAt: DateTime(2025, 6, 1),
      jarId: jarFinancialFreedom,
    ),
  ];
}
