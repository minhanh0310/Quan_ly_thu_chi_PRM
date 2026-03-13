import 'package:Quan_ly_thu_chi_PRM/core/widgets/template/function_screen_template.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/widget/search_bar_with_filter_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/data/mock_transaction.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/widget/filter_tab_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/ledger/widget/transaction_item_widget.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    List<Map<String, dynamic>> filtered = mockTransactions;

    if (selectedFilterIndex == 1) {
      filtered = filtered.where((t) => t['isIncome'] == true).toList();
    } else if (selectedFilterIndex == 2) {
      filtered = filtered.where((t) => t['isIncome'] == false).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
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
                  print('====> Open filter modal');
                  // TODO: Show filter bottom sheet
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
          child: filteredTransactions.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: AppPad.h20,
                  child: Column(
                    children: filteredTransactions.map((transaction) {
                      final cp = context.read<CurrencyProvider>();
                      final raw = (transaction['rawAmount'] as double?) ?? 0.0;
                      final isIncome = transaction['isIncome'] as bool;
                      final formatted =
                          '${isIncome ? '+' : '-'}${cp.formatCurrency(raw)}';
                      return TransactionItemWidget(
                        title: transaction['title'],
                        date: transaction['date'],
                        amount: formatted,
                        category: transaction['category'] ?? '',
                        tag: transaction['tag'],
                        isIncome: isIncome,
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
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
            'No transactions found',
            style: AppTextStyle.s16in.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
