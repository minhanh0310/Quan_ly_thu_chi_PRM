import 'package:flutter/material.dart';

enum SavingsGoalStatus { active, completed, overdue }

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
  });

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
    ),
    SavingsGoalModel(
      id: '4',
      name: 'Buy a Car',
      description: 'First car',
      targetAmount: 500000000,
      currentAmount: 100000000,
      deadline: DateTime(2027, 12, 31),
      color: const Color(0xFF5B4EFF),
      icon: Icons.directions_car_rounded,
      createdAt: DateTime(2025, 1, 1),
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
    ),
  ];
}
