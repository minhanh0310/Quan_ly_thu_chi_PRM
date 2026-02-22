import 'package:Quan_ly_thu_chi_PRM/init.dart';

/// Recent Activity Widget - Sử dụng theme constants và SliverList
class SliverRecentActivityWidget extends StatelessWidget {
  const SliverRecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace với data từ BLoC/Provider
    final mockActivities = [
      {
        'icon': Icons.arrow_downward,
        'iconColor': const Color(0xFF00D09E),
        // TODO: AppColors.incomeGreen
        'backgroundColor': const Color(0xFFE8F8F4),
        // TODO: AppColors.incomeLightGreen
        'title': 'Salary',
        'date': '2024-02-01',
        'amount': '+\$5,000',
        'isIncome': true,
      },
      {
        'icon': Icons.arrow_upward,
        'iconColor': const Color(0xFFFF6B93),
        // TODO: AppColors.expenseRed
        'backgroundColor': const Color(0xFFFFE8EE),
        // TODO: AppColors.expenseLightRed
        'title': 'Rent',
        'date': '2024-02-02',
        'amount': '-\$1,200',
        'isIncome': false,
      },
      {
        'icon': Icons.arrow_upward,
        'iconColor': const Color(0xFFFF6B93),
        'backgroundColor': const Color(0xFFFFE8EE),
        'title': 'Groceries',
        'date': '2024-02-03',
        'amount': '-\$450',
        'isIncome': false,
      },
      {
        'icon': Icons.arrow_downward,
        'iconColor': const Color(0xFF00D09E),
        'backgroundColor': const Color(0xFFE8F8F4),
        'title': 'Freelance',
        'date': '2024-02-04',
        'amount': '+\$2,300',
        'isIncome': true,
      },
    ];

    return SliverPadding(
      padding: AppPad.h20,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return Padding(
                padding: AppPad.a16,
                child: Text(
                  'Recent Activity',
                  style: AppTextStyle.s16in.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              );
            }

            // Activity items từ index 1
            final activityIndex = index - 1;
            if (activityIndex >= mockActivities.length) {
              return null;
            }

            final activity = mockActivities[activityIndex];

            return Padding(
              padding: AppPad.a12,
              child: _ActivityItem(
                icon: activity['icon'] as IconData,
                iconColor: activity['iconColor'] as Color,
                backgroundColor: activity['backgroundColor'] as Color,
                title: activity['title'] as String,
                date: activity['date'] as String,
                amount: activity['amount'] as String,
                isIncome: activity['isIncome'] as bool,
              ),
            );
          },
          childCount: mockActivities.length + 1,
        ),
      ),
    );
  }
}

/// Activity Item Component
class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderRadius.a12,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: AppBorderRadius.a12,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),

          AppGap.w12,

          // Activity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.s14in.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                AppGap.h4,
                Text(
                  date,
                  style: AppTextStyle.s12in.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: AppTextStyle.s16in.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
