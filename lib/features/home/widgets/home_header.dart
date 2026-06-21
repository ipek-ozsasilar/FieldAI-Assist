import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.cardBorder,
            child: Icon(Icons.person, color: AppColors.textSecondary, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'FieldAI Assist',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.primaryNavy),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }
}
