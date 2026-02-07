import 'package:Quan_ly_thu_chi_PRM/common/widgets/images/custom_asset_svg_picture.dart';
import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/initial/model/currency_item_model.dart';

class OnboardingCurrencyScreen extends StatefulWidget {
  const OnboardingCurrencyScreen({super.key});

  @override
  State<OnboardingCurrencyScreen> createState() =>
      _OnboardingCurrencyScreenState();
}

class _OnboardingCurrencyScreenState extends State<OnboardingCurrencyScreen> {
  String? selectedCurrency;

  final List<CurrencyItemModel> currencies = [
    CurrencyItemModel(code: 'VND', symbol: '₫', name: 'Vietnamese Dong'),
    CurrencyItemModel(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyItemModel(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyItemModel(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyItemModel(code: 'GBP', symbol: '£', name: 'British Pound'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppPad.h24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppGap.h40,

                    _buildHeader(),

                    AppGap.h32,

                    _buildCurrencyList(),
                  ],
                ),
              ),
            ),

            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Wallet decoration
        Positioned(
          top: -20,
          right: -20,
          child: Opacity(
            opacity: 0.1,
            child: Image.asset(
              Images.walletLogo,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Select Currency',
              style: AppTextStyle.s24.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            AppGap.h8,

            // Subtitle
            Text(
              'Important: This primary currency cannot be changed later.',
              style: AppTextStyle.s12.copyWith(
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyList() {
    return Column(
      children: currencies.map((currency) {
        final isSelected = selectedCurrency == currency.code;

        return Padding(
          padding: AppPad.b15,
          child: _buildCurrencyItem(
            currency: currency,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                selectedCurrency = currency.code;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrencyItem({
    required CurrencyItemModel currency,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: AppPad.h12v8,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.green
                : AppColors.border.withValues(alpha: 0.1),
            width: isSelected ? 1.05 : 1,
          ),
        ),
        child: Row(
          children: [
            // Currency symbol
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.lightGray.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                currency.symbol,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            AppGap.w16,

            // Currency info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: AppTextStyle.s16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    currency.name,
                    style: AppTextStyle.s12.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ),

            // Check icon when selected
            if (isSelected)
              CustomAssetSvgPicture(
                IconPath.circleCheck,
                width: 20,
                height: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: PrimaryButton(text: 'Finalize Setup', onClick: _handleFinalize),
    );
  }

  void _showFloatingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: AppTextStyle.s16.copyWith(
            fontSize: 16,
            height: 18 / 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.rustyRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleFinalize() {
    // Validate: Check if currency is selected
    if (selectedCurrency == null) {
      _showFloatingSnackBar('Please select a currency to continue');
      return;
    }

    // TODO: Save currency to SharedPreferences or State Management
    // await _saveCurrency(selectedCurrency!);

    // Navigate to next screen
    Navigator.pushReplacementNamed(context, AppRoutes.signin);
  }
}
