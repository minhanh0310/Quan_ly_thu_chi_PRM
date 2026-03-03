import 'package:Quan_ly_thu_chi_PRM/init.dart';
import 'package:Quan_ly_thu_chi_PRM/modules/jar/model/jar_model.dart';

class SliverJarCardWidget extends StatelessWidget {
  final JarModel jar;

  const SliverJarCardWidget({super.key, required this.jar});

  String _formatAmount(double v) {
    final intVal = v.toInt().toString();
    if (intVal.length > 3) {
      return '\$${intVal.substring(0, intVal.length - 3)},${intVal.substring(intVal.length - 3)}';
    }
    return '\$$intVal';
  }

  @override
  Widget build(BuildContext context) {
    final targetPct = (jar.targetPercent * 100).toStringAsFixed(0);
    final actualPct = (jar.actualPercent * 100).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppPad.a16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderRadius.a16,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _JarIcon(color: jar.color, icon: jar.icon),
              AppGap.w12,
              Expanded(
                child: _JarNameBadges(
                  name: jar.name,
                  targetPct: targetPct,
                  actualPct: actualPct,
                  color: jar.color,
                ),
              ),
              _JarAmountDetail(
                amount: _formatAmount(jar.amount),
                color: jar.color,
              ),
            ],
          ),

          AppGap.h12,

          // ── Progress bar ──
          _JarProgressBar(value: jar.actualPercent, color: jar.color),

          AppGap.h10,

          // ── Description ──
          Text(
            '"${jar.description}"',
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
              fontSize: 11,
            ),
          ),

          // ── Active plans count (optional) ──
          if (jar.activePlansCount > 0) ...[
            AppGap.h8,
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            AppGap.h8,
            _ActivePlansRow(count: jar.activePlansCount),
          ],
        ],
      ),
    );
  }
}

class _JarIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _JarIcon({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppBorderRadius.a12,
      ),
      child: Icon(icon, color: AppColors.white, size: 22),
    );
  }
}

class _JarNameBadges extends StatelessWidget {
  final String name;
  final String targetPct;
  final String actualPct;
  final Color color;

  const _JarNameBadges({
    required this.name,
    required this.targetPct,
    required this.actualPct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTextStyle.s14in.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        AppGap.h3,
        Row(
          children: [
            _PillBadge(label: 'TARGET: $targetPct%', color: color),
            AppGap.w8,
            Text(
              'Actual: $actualPct%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.s12in.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _JarAmountDetail extends StatelessWidget {
  final String amount;
  final Color color;

  const _JarAmountDetail({required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount,
          style: AppTextStyle.s14in.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _JarProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const _JarProgressBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppBorderRadius.a4,
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor: color.withValues(alpha: 0.15),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: 5,
      ),
    );
  }
}

class _ActivePlansRow extends StatelessWidget {
  final int count;

  const _ActivePlansRow({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.plans);
          },
          child: Text(
            'Nurturing $count active plans',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.s12in.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PillBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPad.h6v2,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppBorderRadius.a20,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.s12in.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
