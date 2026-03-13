import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Quan_ly_thu_chi_PRM/models/transaction_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/savings_goal_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/budget_model.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/plans/model/recurring_transaction_model.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/serialization_helpers.dart';

class FinanceDatabaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  DatabaseReference _financeRoot(String uid) => _db.ref('finance').child(uid);

  DatabaseReference _jarsRef(String uid) => _financeRoot(uid).child('jars');
  DatabaseReference _transactionsRef(String uid) =>
      _financeRoot(uid).child('transactions');
  DatabaseReference _goalsRef(String uid) =>
      _financeRoot(uid).child('savingsGoals');
  DatabaseReference _budgetsRef(String uid) =>
      _financeRoot(uid).child('budgets');
  DatabaseReference _recurringRef(String uid) =>
      _financeRoot(uid).child('recurring');
  DatabaseReference _distributionsRef(String uid) =>
      _financeRoot(uid).child('jarDistributions');

  static const List<_JarDefinition> _defaultJars = [
    _JarDefinition(
      id: 'necessities',
      name: 'Necessities',
      description: 'Living expenses, food, utility bills',
      color: Color(0xFF4CAF50),
      icon: Icons.home_rounded,
      targetPercent: 0.55,
    ),
    _JarDefinition(
      id: 'financial_freedom',
      name: 'Financial Freedom',
      description: 'Invest, accumulate for big plans',
      color: Color(0xFF5B4EFF),
      icon: Icons.trending_up_rounded,
      targetPercent: 0.10,
    ),
    _JarDefinition(
      id: 'education',
      name: 'Education',
      description: 'Learning, personal development',
      color: Color(0xFFFFC94D),
      icon: Icons.school_rounded,
      targetPercent: 0.10,
    ),
    _JarDefinition(
      id: 'long_term_savings',
      name: 'Long-term Savings',
      description: 'Emergency fund, big purchases',
      color: Color(0xFF26C6DA),
      icon: Icons.account_balance_rounded,
      targetPercent: 0.10,
    ),
    _JarDefinition(
      id: 'entertainment',
      name: 'Entertainment',
      description: 'Values, travel, rewards',
      color: Color(0xFFFF6B93),
      icon: Icons.celebration_rounded,
      targetPercent: 0.10,
    ),
    _JarDefinition(
      id: 'give',
      name: 'Give',
      description: 'Charity, gifts, helping others',
      color: Color(0xFFAB47BC),
      icon: Icons.volunteer_activism_rounded,
      targetPercent: 0.05,
    ),
  ];

  static List<String> get jarOrder =>
      _defaultJars.map((e) => e.id).toList();

  Future<void> ensureDefaultJars(String uid) async {
    final snapshot = await _jarsRef(uid).get();
    if (snapshot.exists) return;
    final data = <String, dynamic>{};
    for (final def in _defaultJars) {
      data[def.id] = JarModel(
        id: def.id,
        name: def.name,
        description: def.description,
        color: def.color,
        icon: def.icon,
        targetPercent: def.targetPercent,
        actualPercent: 0,
        amount: 0,
        activePlansCount: 0,
      ).toMap();
    }
    await _jarsRef(uid).set(data);
  }

  Stream<List<JarModel>> watchJars(String uid) {
    return _jarsRef(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final jars = <JarModel>[];
      data.forEach((key, value) {
        if (value is Map) {
          jars.add(JarModel.fromMap(key.toString(), value));
        }
      });
      jars.sort(
        (a, b) => jarOrder
            .indexOf(a.id ?? '')
            .compareTo(jarOrder.indexOf(b.id ?? '')),
      );
      return _applyActualPercent(jars);
    });
  }

  Stream<List<DistributionEntry>> watchDistributions(String uid) {
    return _distributionsRef(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final entries = <DistributionEntry>[];
      data.forEach((key, value) {
        if (value is Map) {
          entries.add(DistributionEntry.fromMap(key.toString(), value));
        }
      });
      entries.sort((a, b) => b.month.compareTo(a.month));
      return entries;
    });
  }

  Stream<List<TransactionModel>> watchTransactions(String uid) {
    return _transactionsRef(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final items = <TransactionModel>[];
      data.forEach((key, value) {
        if (value is Map) {
          items.add(TransactionModel.fromMap(key.toString(), value));
        }
      });
      items.sort((a, b) => b.date.compareTo(a.date));
      return items;
    });
  }

  Stream<List<SavingsGoalModel>> watchSavingsGoals(String uid) {
    return _goalsRef(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final items = <SavingsGoalModel>[];
      data.forEach((key, value) {
        if (value is Map) {
          items.add(SavingsGoalModel.fromMap(key.toString(), value));
        }
      });
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    });
  }

  Stream<List<BudgetModel>> watchBudgets(String uid) {
    return _budgetsRef(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final items = <BudgetModel>[];
      data.forEach((key, value) {
        if (value is Map) {
          items.add(BudgetModel.fromMap(key.toString(), value));
        }
      });
      return items;
    });
  }

  Stream<List<RecurringTransactionModel>> watchRecurringTransactions(String uid) {
    return _recurringRef(uid).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final items = <RecurringTransactionModel>[];
      data.forEach((key, value) {
        if (value is Map) {
          items.add(RecurringTransactionModel.fromMap(key.toString(), value));
        }
      });
      items.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
      return items;
    });
  }

  Future<void> setRecurringActive({
    required String uid,
    required String id,
    required bool isActive,
  }) async {
    await _recurringRef(uid).child(id).update({'isActive': isActive});
  }

  Future<void> addIncome({
    required String uid,
    required double amount,
    required DateTime date,
    String title = 'Income',
    String? note,
    List<String>? tags,
  }) async {
    await ensureDefaultJars(uid);
    final distribution = _buildDistribution(amount);
    final updates = <String, dynamic>{};
    for (final entry in distribution.entries) {
      updates['jars/${entry.key}/amount'] =
          ServerValue.increment(entry.value);
    }
    final txId = _transactionsRef(uid).push().key!;
    final transaction = TransactionModel(
      id: txId,
      title: title,
      amount: amount,
      isIncome: true,
      category: 'INCOME',
      date: date,
      createdAt: DateTime.now(),
      note: note,
      tags: tags ?? const [],
    );
    updates['transactions/$txId'] = transaction.toMap();

    final monthLabel = '${_monthName(date.month)} ${date.year}';
    final distId = _distributionsRef(uid).push().key!;
    updates['jarDistributions/$distId'] = DistributionEntry(
      id: distId,
      month: monthLabel,
      subtitle: 'Auto distributed',
      amount: amount,
    ).toMap();

    await _financeRoot(uid).update(updates);
  }

  Future<void> addExpense({
    required String uid,
    required double amount,
    required DateTime date,
    required String category,
    String? note,
    List<String>? tags,
  }) async {
    await ensureDefaultJars(uid);
    final jarId = _jarIdFromName(category) ?? 'necessities';
    final updates = <String, dynamic>{
      'jars/$jarId/amount': ServerValue.increment(-amount),
    };
    final txId = _transactionsRef(uid).push().key!;
    final transaction = TransactionModel(
      id: txId,
      title: category,
      amount: amount,
      isIncome: false,
      category: category,
      jarId: jarId,
      date: date,
      createdAt: DateTime.now(),
      note: note,
      tags: tags ?? const [],
    );
    updates['transactions/$txId'] = transaction.toMap();
    await _financeRoot(uid).update(updates);
  }

  Future<void> createSavingsGoal({
    required String uid,
    required String name,
    required double targetAmount,
    required DateTime deadline,
    Color color = const Color(0xFF6C5CE7),
    IconData icon = Icons.flag_rounded,
    String? description,
    String? jarId,
  }) async {
    final id = _goalsRef(uid).push().key!;
    final goal = SavingsGoalModel(
      id: id,
      name: name,
      description: description,
      targetAmount: targetAmount,
      currentAmount: 0,
      deadline: deadline,
      color: color,
      icon: icon,
      createdAt: DateTime.now(),
      jarId: jarId ?? SavingsGoalModel.jarFinancialFreedom,
    );
    await _goalsRef(uid).child(id).set(goal.toMap());
  }

  Future<void> allocateToGoal({
    required String uid,
    required SavingsGoalModel goal,
    required double amount,
  }) async {
    if (amount <= 0) return;
    await ensureDefaultJars(uid);
    final now = DateTime.now();
    final history = [
      ...goal.accumulationHistory,
      AccumulationEntry(
        date: now,
        title: 'Savings ${now.month}/${now.year}',
        subtitle: 'Transfer from financial freedom',
        amount: amount,
      ),
    ];
    final updatedGoal = goal.copyWith(
      currentAmount: goal.currentAmount + amount,
      accumulationHistory: history,
    );
    final updates = <String, dynamic>{
      'savingsGoals/${goal.id}': updatedGoal.toMap(),
      'jars/${SavingsGoalModel.jarFinancialFreedom}/amount':
          ServerValue.increment(-amount),
    };

    final txId = _transactionsRef(uid).push().key!;
    updates['transactions/$txId'] = TransactionModel(
      id: txId,
      title: 'Plan: ${goal.name}',
      amount: amount,
      isIncome: false,
      category: 'PLAN',
      jarId: SavingsGoalModel.jarFinancialFreedom,
      planId: goal.id,
      date: now,
      createdAt: now,
      note: 'Contribution',
      tags: const ['plan'],
    ).toMap();

    await _financeRoot(uid).update(updates);
  }

  Map<String, double> _buildDistribution(double amount) {
    final distribution = <String, double>{};
    double allocated = 0;
    for (final def in _defaultJars) {
      final value = (amount * def.targetPercent);
      distribution[def.id] = value;
      allocated += value;
    }
    final remainder = amount - allocated;
    if (remainder.abs() > 0.0001) {
      distribution[_defaultJars.first.id] =
          (distribution[_defaultJars.first.id] ?? 0) + remainder;
    }
    return distribution;
  }

  List<JarModel> _applyActualPercent(List<JarModel> jars) {
    final total = jars.fold<double>(0, (sum, jar) => sum + jar.amount);
    if (total <= 0) return jars;
    return jars
        .map(
          (j) => JarModel(
            id: j.id,
            name: j.name,
            description: j.description,
            color: j.color,
            icon: j.icon,
            targetPercent: j.targetPercent,
            actualPercent: (j.amount / total).clamp(0.0, 1.0),
            amount: j.amount,
            activePlansCount: j.activePlansCount,
          ),
        )
        .toList();
  }

  String? _jarIdFromName(String name) {
    for (final def in _defaultJars) {
      if (def.name.toLowerCase() == name.toLowerCase()) {
        return def.id;
      }
    }
    return null;
  }

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[(month - 1).clamp(0, 11)];
  }
}

class _JarDefinition {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final double targetPercent;

  const _JarDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.targetPercent,
  });
}
