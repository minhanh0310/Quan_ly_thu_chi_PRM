import 'package:Quan_ly_thu_chi_PRM/init.dart';

class SliverActivePlansWidget extends StatelessWidget {
  const SliverActivePlansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: AppPad.h20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Plans',
                  style: AppTextStyle.s12in.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all plans
                    print('====> View All Plans');
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Plans List - Horizontal Scrollable
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 2, // TODO: Replace với plans.length từ state
              separatorBuilder: (context, index) => AppGap.h16,
              itemBuilder: (context, index) {
                // TODO: Replace với data thật
                if (index == 0) {
                  return _PlanCard(
                    title: 'Buy a House',
                    current: '\$125,000',
                    target: '\$500,000',
                    progress: 0.25,
                    imageUrl: 'assets/images/house.jpg',
                    color: const Color(0xFF6C5CE7),
                  );
                } else {
                  return _PlanCard(
                    title: 'Buy a Tesla',
                    current: '\$15,000',
                    target: '\$60,000',
                    progress: 0.25,
                    imageUrl: 'assets/images/tesla.jpg',
                    color: const Color(0xFFFF6B93),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String current;
  final String target;
  final double progress;
  final String imageUrl;
  final Color color;

  const _PlanCard({
    required this.title,
    required this.current,
    required this.target,
    required this.progress,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 68,
              height: 68,
              color: Colors.grey[200],
              // TODO: Replace với Image.asset(imageUrl) hoặc CachedNetworkImage
              child: Icon(Icons.image, color: Colors.grey[400], size: 32),
            ),
          ),

          const SizedBox(width: 12),

          // Plan Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$current / $target',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
