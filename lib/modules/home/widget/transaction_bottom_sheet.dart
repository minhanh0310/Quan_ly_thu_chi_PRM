import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/services/finance_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Quan_ly_thu_chi_PRM/core/providers/currency_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Quan_ly_thu_chi_PRM/utils/helpers/category_tr.dart';

// Category translation keys for 6 Jars
const _categoryKeys = [
  'tags.necessities',
  'tags.financial_freedom',
  'tags.education',
  'tags.long_term_savings',
  'tags.entertainment',
  'tags.give',
];

void showAddTransactionBottomSheet(
  BuildContext context, {
  bool isIncome = true,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddTransactionBottomSheet(isIncome: isIncome),
  );
}

class AddTransactionBottomSheet extends StatefulWidget {
  final bool isIncome;

  const AddTransactionBottomSheet({super.key, required this.isIncome});

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  late bool _isIncome;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  double _selectedJarBalance = 0.0;
  bool _isBalanceSufficient = true;

  List<String> get _categories => _categoryKeys;

  @override
  void initState() {
    super.initState();
    _isIncome = widget.isIncome;
    _amountController.addListener(_validateAmount);
  }

  @override
  void dispose() {
    _amountController.removeListener(_validateAmount);
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    if (_isIncome) return;

    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0;

    setState(() {
      _isBalanceSufficient = amount <= _selectedJarBalance;
    });
  }

  Future<void> _updateJarBalance() async {
    if (_isIncome || _selectedCategory == null) {
      setState(() {
        _selectedJarBalance = 0.0;
        _isBalanceSufficient = true;
      });
      return;
    }

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final service = FinanceDatabaseService();
      final categoryKey = _selectedCategory ?? _categories.first;

      // Map category to jar ID
      final jarIdMap = {
        'tags.necessities': 'necessities',
        'tags.financial_freedom': 'financial_freedom',
        'tags.education': 'education',
        'tags.long_term_savings': 'long_term_savings',
        'tags.entertainment': 'entertainment',
        'tags.give': 'give',
      };

      final jarId = jarIdMap[categoryKey] ?? 'necessities';
      final balance = await service.getJarBalance(uid: uid, jarId: jarId);

      setState(() {
        _selectedJarBalance = balance;
        _validateAmount();
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _onSave() async {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0;
    final note = _noteController.text.trim();

    // Tách từng từ: từ có # giữ nguyên, từ không có # tự thêm #
    // Ví dụ: "work salary #bonus" → tags: [work, salary, bonus], noteText: ""
    final tagRegex = RegExp(r'#\w+');
    final wordRegex = RegExp(r'\b\w+\b');

    List<String> tags;
    String noteText;

    if (tagRegex.hasMatch(note)) {
      // Có ít nhất 1 từ có # → dùng logic cũ: chỉ lấy từ có #, phần còn lại là note
      tags = tagRegex
          .allMatches(note)
          .map((m) => (m.group(0) ?? '').replaceAll('#', ''))
          .toList();
      noteText = note.replaceAll(tagRegex, '').trim();
    } else if (note.isNotEmpty) {
      // Không có # → toàn bộ từ đều thành tag
      tags = wordRegex
          .allMatches(note)
          .map((m) => m.group(0) ?? '')
          .where((w) => w.isNotEmpty)
          .toList();
      noteText = '';
    } else {
      tags = [];
      noteText = '';
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('home_screen.sign_in_warning'.tr()),
          backgroundColor: AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (amount <= 0) {
      return;
    }
    if (!_isIncome && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('home_screen.select_tag_warning'.tr()),
          backgroundColor: AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final category = _selectedCategory ?? _categories.first;
    // Lưu translation key làm title để khi đổi ngôn ngữ vẫn dịch đúng
    // trCategory() sẽ dịch lúc hiển thị
    final service = FinanceDatabaseService();
    try {
      if (_isIncome) {
        await service.addIncome(
          uid: uid,
          amount: amount,
          date: _selectedDate,
          title: category, // lưu key: 'tags.necessities', 'INCOME'...
          note: noteText,
          tags: tags,
        );
      } else {
        await service.addExpense(
          uid: uid,
          amount: amount,
          date: _selectedDate,
          category: category,
          title: category, // lưu key, không lưu tên đã dịch
          note: noteText,
          tags: tags,
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isIncome
                ? 'home_screen.saved_income'.tr()
                : 'home_screen.saved_expense'.tr(),
          ),
          backgroundColor: _isIncome
              ? AppColors.incomeGreen
              : AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString();
      final displayMessage = errorMessage.contains('Exception:')
          ? errorMessage.replaceAll('Exception: ', '')
          : 'Save failed: $errorMessage';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(displayMessage),
          backgroundColor: AppColors.expenseRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primaryPurple),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.vertical(top: AppRadius.c24),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            Padding(
              padding: AppPad.h20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildAmountDisplay(),
                  const SizedBox(height: 20),
                  _buildSectionLabel('home_screen.tags'.tr()),
                  const SizedBox(height: 10),
                  _buildCategoryChips(),
                  if (!_isIncome && _selectedCategory != null) ...[
                    const SizedBox(height: 12),
                    _buildJarBalanceInfo(),
                  ],
                  const SizedBox(height: 16),
                  _buildDateRow(),
                  const SizedBox(height: 16),
                  _buildNoteField(),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onClick: _onSave,
                    text: _isIncome
                        ? 'home_screen.save_income'.tr()
                        : 'home_screen.save_expense'.tr(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.borderColor,
          borderRadius: AppBorderRadius.a8,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'home_screen.record_transaction'.tr(),
          style: AppTextStyle.s16in.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: context.primaryTextColor,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.surfaceVariant,
              borderRadius: AppBorderRadius.a8,
            ),
            child: Icon(
              Icons.close,
              size: 18,
              color: context.secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppPad.a4,
          decoration: BoxDecoration(
            color: context.surfaceVariant,
            borderRadius: AppBorderRadius.a12,
          ),
          child: Row(
            children: [
              _buildToggleTab(
                label: 'home_screen.income'.tr(),
                isSelected: _isIncome,
                onTap: () => setState(() {
                  _isIncome = true;
                  if (_selectedCategory != null &&
                      !_categoryKeys.contains(_selectedCategory)) {
                    _selectedCategory = null;
                  }
                }),
              ),
              _buildToggleTab(
                label: 'home_screen.expense'.tr(),
                isSelected: !_isIncome,
                onTap: () => setState(() {
                  _isIncome = false;
                  if (_selectedCategory != null &&
                      !_categoryKeys.contains(_selectedCategory)) {
                    _selectedCategory = null;
                  }
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('home_screen.amount'.tr()),
        const SizedBox(height: 8),
        _buildAmountField(),
      ],
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: AppBorderRadius.a16,
      ),
      child: Row(
        children: [
          Text(
            context.read<CurrencyProvider>().symbol,
            style: AppTextStyle.s24in.copyWith(
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: AppTextStyle.s28in.copyWith(
                color: context.primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: AppTextStyle.s28in.copyWith(
                  color: context.hintColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppPad.v10,
          decoration: BoxDecoration(
            color: isSelected ? context.surfaceColor : Colors.transparent,
            borderRadius: AppBorderRadius.a10,
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.s14in.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? (_isIncome ? AppColors.incomeGreen : AppColors.expenseRed)
                    : AppColors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppTextStyle.s12in.copyWith(color: context.secondaryTextColor),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;

        return GestureDetector(
          onTap: () {
            final wasSelected = _selectedCategory == cat;
            setState(() {
              _selectedCategory = wasSelected ? null : cat;
            });
            // Update jar balance after selection
            if (!wasSelected) {
              _updateJarBalance();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: AppPad.h12v8,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.1)
                  : context.surfaceVariant,
              borderRadius: AppBorderRadius.a20,
              border: Border.all(
                color: isSelected ? context.primaryColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              cat.tr(),
              style: AppTextStyle.s12in.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? context.primaryColor
                    : context.secondaryTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateRow() {
    final formatted =
        '${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.year}';

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: AppPad.h16v14,
        decoration: BoxDecoration(
          color: context.surfaceVariant,
          borderRadius: AppBorderRadius.a12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: context.secondaryTextColor,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home_screen.transaction_date'.tr(),
                  style: AppTextStyle.s12in.copyWith(
                    color: context.secondaryTextColor,
                    fontSize: 10,
                  ),
                ),
                Text(
                  formatted,
                  style: AppTextStyle.s14in.copyWith(
                    color: context.primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: context.secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('home_screen.note'.tr()),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          style: AppTextStyle.s14in.copyWith(color: context.primaryTextColor),
          decoration: InputDecoration(
            hintText: 'home_screen.hint_note'.tr(),
            hintStyle: AppTextStyle.s14in.copyWith(color: context.hintColor),
            filled: true,
            fillColor: context.surfaceVariant,
            contentPadding: AppPad.h16v14,
            border: OutlineInputBorder(
              borderRadius: AppBorderRadius.a12,
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              Icons.tag,
              size: 18,
              color: context.secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJarBalanceInfo() {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0;
    final remaining = _selectedJarBalance - amount;
    final currencyProvider = context.read<CurrencyProvider>();
    final formattedBalance = currencyProvider.formatCurrency(
      _selectedJarBalance,
    );
    final formattedRemaining = currencyProvider.formatCurrency(
      remaining.clamp(0, double.infinity),
    );

    return Container(
      padding: AppPad.a12,
      decoration: BoxDecoration(
        color: _isBalanceSufficient
            ? AppColors.incomeGreen.withValues(alpha: 0.1)
            : AppColors.expenseRed.withValues(alpha: 0.1),
        borderRadius: AppBorderRadius.a12,
        border: Border.all(
          color: _isBalanceSufficient
              ? AppColors.incomeGreen.withValues(alpha: 0.3)
              : AppColors.expenseRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home_screen.available_balance'.tr(),
                style: AppTextStyle.s12in.copyWith(
                  color: context.secondaryTextColor,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedBalance,
                style: AppTextStyle.s14in.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.incomeGreen,
                ),
              ),
            ],
          ),
          if (amount > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'plans_screen.remaining_label'.tr(),
                  style: AppTextStyle.s12in.copyWith(
                    color: context.secondaryTextColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedRemaining,
                  style: AppTextStyle.s14in.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isBalanceSufficient
                        ? AppColors.incomeGreen
                        : AppColors.expenseRed,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
