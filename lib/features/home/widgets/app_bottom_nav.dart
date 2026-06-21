import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum HomeTab { home, archive, aiAssist, settings }

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final HomeTab selectedTab;
  final ValueChanged<HomeTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: selectedTab == HomeTab.home,
              onTap: () => onTabSelected(HomeTab.home),
            ),
            _NavItem(
              icon: Icons.inventory_2_outlined,
              label: 'Archive',
              selected: selectedTab == HomeTab.archive,
              onTap: () => onTabSelected(HomeTab.archive),
            ),
            _NavItem(
              icon: Icons.psychology_outlined,
              label: 'AI Assist',
              selected: selectedTab == HomeTab.aiAssist,
              onTap: () => onTabSelected(HomeTab.aiAssist),
            ),
            _NavItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: selectedTab == HomeTab.settings,
              onTap: () => onTabSelected(HomeTab.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected ? AppColors.navSelectedBg : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: selected ? AppColors.primaryNavy : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AppColors.primaryNavy : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
