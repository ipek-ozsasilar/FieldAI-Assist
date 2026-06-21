import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'data/mock_home_data.dart';
import 'widgets/ai_insight_banner.dart';
import 'widgets/app_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/job_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _selectedTab = HomeTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: AppBottomNav(
        selectedTab: _selectedTab,
        onTabSelected: (tab) => setState(() => _selectedTab = tab),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                children: [
                  Text(
                    'Hello, ${MockHomeData.technicianName}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${MockHomeData.dateLabel} • ${MockHomeData.activeJobCount} active jobs',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AiInsightBanner(
                    title: MockHomeData.aiInsightTitle,
                    body: MockHomeData.aiInsightBody,
                  ),
                  const SizedBox(height: 20),
                  ...MockHomeData.jobs.map(
                    (job) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: JobCard(job: job),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
