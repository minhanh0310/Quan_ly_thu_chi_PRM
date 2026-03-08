import 'package:Quan_ly_thu_chi_PRM/init.dart';

// 6 Jars categories
const _incomeCategories = [
  'Necessities',
  'Financial Freedom',
  'Education',
  'Long-term Savings',
  'Entertainment',
  'Give',
];

const _expenseCategories = [
  'Necessities',
  'Financial Freedom',
  'Education',
  'Long-term Savings',
  'Entertainment',
  'Give',
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

  List<String> get _categories =>
      _isIncome ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    _isIncome = widget.isIncome;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSave() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final note = _noteController.text.trim();

    final tagRegex = RegExp(r'#\w+');

    final tags = tagRegex
        .allMatches(note)
        .map((m) => m.group(0) ?? '')
        .toList();

    final noteText = note.replaceAll(tagRegex, '').trim();

    print('====> Save Transaction');
    print('Type: ${_isIncome ? 'Income' : 'Expense'}');
    print('Amount: $amount');
    print('Category: $_selectedCategory');
    print('Date: $_selectedDate');
    print('Note: $noteText');
    print('Tags: $tags');

    Navigator.pop(context);
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
                  _buildSectionLabel('Tags'),
                  const SizedBox(height: 10),
                  _buildCategoryChips(),
                  const SizedBox(height: 16),
                  _buildDateRow(),
                  const SizedBox(height: 16),
                  _buildNoteField(),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onClick: _onSave,
                    text: _isIncome ? 'Save Income' : 'Save Expense',
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
          'Record Transaction',
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
                label: 'Income',
                isSelected: _isIncome,
                onTap: () => setState(() => _isIncome = true),
              ),
              _buildToggleTab(
                label: 'Expense',
                isSelected: !_isIncome,
                onTap: () => setState(() => _isIncome = false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionLabel('Amount'),
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
            '\$',
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
            setState(() {
              _selectedCategory = isSelected ? null : cat;
            });
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
              cat,
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
                  'Transaction Date',
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
        _buildSectionLabel('Note'),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          style: AppTextStyle.s14in.copyWith(color: context.primaryTextColor),
          decoration: InputDecoration(
            hintText: 'e.g. Monthly salary #work',
            hintStyle: AppTextStyle.s14in.copyWith(color: context.hintColor),
            filled: true,
            fillColor: context.surfaceVariant,
            contentPadding: AppPad.h16v14,
            border: OutlineInputBorder(
              borderRadius: AppBorderRadius.a12,
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              Icons.notes_outlined,
              size: 18,
              color: context.secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
