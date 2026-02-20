import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SliverRecentActivityWidget extends StatelessWidget {
  const SliverRecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace với data thật từ BLoC/Provider
    final mockActivities = [
      {
        'icon': Icons.arrow_downward,
        'iconColor': const Color(0xFF00D09E),
        'backgroundColor': const Color(0xFFE8F8F4),
        'title': 'Salary',
        'date': '2024-02-01',
        'amount': '+\$5,000',
        'isIncome': true,
      },
      {
        'icon': Icons.arrow_upward,
        'iconColor': const Color(0xFFFF6B93),
        'backgroundColor': const Color(0xFFFFE8EE),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Header ở index 0
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              );
            }

            // Activity items từ index 1 trở đi
            final activityIndex = index - 1;
            if (activityIndex >= mockActivities.length) {
              return null;
            }

            final activity = mockActivities[activityIndex];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
          childCount: mockActivities.length + 1, // +1 for header
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),

          const SizedBox(width: 12),

          // Activity Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF00D09E)
                  : const Color(0xFFFF6B93),
            ),
          ),
        ],
      ),
    );
  }
}
