import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AiInsightBanner extends StatelessWidget {
  const AiInsightBanner({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.aiBannerBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI INSIGHT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.aiBannerText.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.aiBannerText.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.psychology_outlined,
            size: 36,
            color: AppColors.aiBannerText.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
