import 'package:Quan_ly_thu_chi_PRM/core/widgets/template/function_screen_template.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/widget/search_bar_with_filter_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/widget/filter_tab_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/widget/transaction_item_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:Quan_ly_thu_chi_PRM/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LedgerScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const LedgerScreen({super.key, this.onOpenDrawer});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  @override
  Widget build(BuildContext context) {
    return FunctionScreenTemplate(
      backgroundColor: context.backgroundColor,
      onOpenDrawer: widget.onOpenDrawer,
      screen: _Body(onOpenDrawer: widget.onOpenDrawer),
    );
  }
}

class _Body extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const _Body({this.onOpenDrawer});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final TextEditingController _searchController = TextEditingController();
  int selectedFilterIndex = 0;
  DateTimeRange? _dateRange;
  String? _categoryFilter;

  static const List<String> _categories = [
    'Necessities',
    'Financial Freedom',
    'Education',
    'Long-term Savings',
    'Entertainment',
    'Give',
    'INCOME',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionModel> _filteredTransactions(
    List<TransactionModel> input,
  ) {
    var filtered = input;
    if (selectedFilterIndex == 1) {
      filtered = filtered.where((t) => t.isIncome).toList();
    } else if (selectedFilterIndex == 2) {
      filtered = filtered.where((t) => !t.isIncome).toList();
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((t) {
        final hay = [
          t.title,
          t.category,
          t.note ?? '',
          ...t.tags,
        ].join(' ').toLowerCase();
        return hay.contains(query);
      }).toList();
    }
    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.category.toLowerCase() ==
              _categoryFilter!.toLowerCase())
          .toList();
    }
    if (_dateRange != null) {
      final start = DateTime(
        _dateRange!.start.year,
        _dateRange!.start.month,
        _dateRange!.start.day,
      );
      final end = DateTime(
        _dateRange!.end.year,
        _dateRange!.end.month,
        _dateRange!.end.day,
        23,
        59,
        59,
      );
      filtered = filtered
          .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
          .toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final service = FinanceDatabaseService();
    return Column(
      children: [
        Padding(
          padding: AppPad.h20,
          child: Column(
            children: [
              AppGap.h20,

              // HeaderWidget(title: 'Ledger', subtitle: 'Ledger Detail'),

              // AppGap.h20,
              SearchBarWithFilterWidget(
                controller: _searchController,
                onFilterTap: () {
                  _showFilterSheet();
                },
              ),

              AppGap.h15,

              FilterTabWidget(
                onTabChanged: (index) {
                  setState(() {
                    selectedFilterIndex = index;
                  });
                },
              ),

              AppGap.h20,
            ],
          ),
        ),

        Expanded(
          child: StreamBuilder<List<TransactionModel>>(
            stream: uid == null ? Stream.empty() : service.watchTransactions(uid),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const [];
              final filtered = _filteredTransactions(items);
              if (filtered.isEmpty) {
                return _buildEmptyState();
              }
              return SingleChildScrollView(
                padding: AppPad.h20,
                child: Column(
                  children: filtered.map((transaction) {
                    final cp = context.read<CurrencyProvider>();
                    final formatted =
                        '${transaction.isIncome ? '+' : '-'}${cp.formatCurrency(transaction.amount)}';
                    final date =
                        '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}-${transaction.date.day.toString().padLeft(2, '0')}';
                    return TransactionItemWidget(
                      title: transaction.title,
                      date: date,
                      amount: formatted,
                      category: transaction.category,
                      tag: transaction.tags.isNotEmpty ? transaction.tags.first : null,
                      isIncome: transaction.isIncome,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showFilterSheet() async {
    DateTimeRange? tempRange = _dateRange;
    String? tempCategory = _categoryFilter;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final rangeText = tempRange == null
                ? 'All time'
                : '${tempRange!.start.day}/${tempRange!.start.month}/${tempRange!.start.year} - ${tempRange!.end.day}/${tempRange!.end.month}/${tempRange!.end.year}';
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: AppPad.a20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter',
                      style: AppTextStyle.s18in.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppGap.h16,
                    Text(
                      'Time range',
                      style: AppTextStyle.s12in.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppGap.h8,
                    InkWell(
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          initialDateRange: tempRange,
                        );
                        if (picked != null) {
                          setModalState(() => tempRange = picked);
                        }
                      },
                      child: Container(
                        padding: AppPad.h16v12,
                        decoration: BoxDecoration(
                          color: context.surfaceVariant,
                          borderRadius: AppBorderRadius.a12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              size: 18,
                              color: context.secondaryTextColor,
                            ),
                            AppGap.w8,
                            Text(
                              rangeText,
                              style: AppTextStyle.s14in.copyWith(
                                color: context.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppGap.h16,
                    Text(
                      'Category',
                      style: AppTextStyle.s12in.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppGap.h8,
                    DropdownButtonFormField<String?>(
                      value: tempCategory,
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All'),
                        ),
                        ..._categories.map(
                          (c) => DropdownMenuItem<String?>(
                            value: c,
                            child: Text(c),
                          ),
                        ),
                      ],
                      onChanged: (value) => setModalState(() {
                        tempCategory = value;
                      }),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: AppBorderRadius.a12,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    AppGap.h20,
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _dateRange = null;
                                _categoryFilter = null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Clear'),
                          ),
                        ),
                        AppGap.w12,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _dateRange = tempRange;
                                _categoryFilter = tempCategory;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              foregroundColor: AppColors.white,
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                    AppGap.h10,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: context.secondaryTextColor.withValues(alpha: 0.5),
          ),
          AppGap.h16,
          Text(
            'ledger_screen.no_transactions'.tr(),
            style: AppTextStyle.s16in.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
