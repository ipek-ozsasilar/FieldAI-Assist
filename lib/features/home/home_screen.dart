import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/job.dart';
import '../jobs/models/ai_priority_model.dart';
import '../jobs/services/job_api_service.dart';
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
  final JobApiService jobApiService = JobApiService();

  HomeTab _selectedTab = HomeTab.home;
  bool isLoadingJobs = true;
  bool isPrioritizing = false;
  String? aiSummary;
  Map<String, AiJobPriority> priorityByJobId = {};
  Map<String, int> priorityOrderByJobId = {};
  List<Job> jobs = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTodayJobs();
    });
  }

  Future<void> loadTodayJobs() async {
    setState(() {
      isLoadingJobs = true;
      aiSummary = null;
      priorityByJobId = {};
      priorityOrderByJobId = {};
    });

    try {
      final todayJobs = await jobApiService.getTodayJobs();

      if (!mounted) return;

      setState(() {
        jobs = todayJobs;
      });
    } catch (error, stackTrace) {
      debugPrint('Bugünkü işler alınırken hata: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        jobs = MockHomeData.jobs;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bugünkü işler alınamadı: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoadingJobs = false;
        });
      }
    }
  }

  Future<void> prioritizeJobsWithAi() async {
    setState(() {
      isPrioritizing = true;
    });

    try {
      final aiResult = await jobApiService.prioritizeTodayJobs();

      final priorityMap = {
        for (final item in aiResult.priorities)
          _normalizeJobId(item.jobId): item,
      };
      final priorityOrderMap = {
        for (final indexedItem in aiResult.priorities.indexed)
          _normalizeJobId(indexedItem.$2.jobId): indexedItem.$1,
      };

      if (!mounted) return;

      setState(() {
        aiSummary = aiResult.summary;
        priorityByJobId = priorityMap;
        priorityOrderByJobId = priorityOrderMap;
        if (aiResult.jobs.isNotEmpty) {
          jobs = aiResult.jobs;
        }
      });
    } catch (error, stackTrace) {
      debugPrint('AI önceliklendirme hatası: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI önceliklendirme başarısız: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPrioritizing = false;
        });
      }
    }
  }

  String _normalizeJobId(String jobId) {
    final normalized = jobId.trim();

    if (normalized.toUpperCase().startsWith('JOB-')) {
      return normalized.substring(4);
    }

    return normalized;
  }

  List<Job> get _prioritizedJobs {
    final sortedJobs = [...jobs];

    if (priorityByJobId.isEmpty) {
      return sortedJobs;
    }

    sortedJobs.sort((first, second) {
      final firstPriority = priorityByJobId[_normalizeJobId(first.id)];
      final secondPriority = priorityByJobId[_normalizeJobId(second.id)];
      final firstRank = _priorityRank(firstPriority?.priority);
      final secondRank = _priorityRank(secondPriority?.priority);

      if (firstRank != secondRank) {
        return firstRank.compareTo(secondRank);
      }

      final firstOrder = priorityOrderByJobId[_normalizeJobId(first.id)] ?? 999;
      final secondOrder =
          priorityOrderByJobId[_normalizeJobId(second.id)] ?? 999;

      return firstOrder.compareTo(secondOrder);
    });

    return sortedJobs;
  }

  int _priorityRank(String? priority) {
    switch (priority) {
      case 'high':
        return 0;
      case 'medium':
        return 1;
      case 'low':
        return 2;
      default:
        return 3;
    }
  }

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
                    '${MockHomeData.dateLabel} • ${jobs.length} active jobs',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AiInsightBanner(
                    title: 'AI önerisi',
                    body: aiSummary ?? 'AI önerisi henüz yok.',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoadingJobs || isPrioritizing
                          ? null
                          : prioritizeJobsWithAi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isPrioritizing
                            ? 'AI analiz ediyor...'
                            : 'AI ile Önceliklendir',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isLoadingJobs)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_prioritizedJobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'Bugün için iş bulunamadı.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._prioritizedJobs.map((job) {
                      final aiPriority =
                          priorityByJobId[_normalizeJobId(job.id)];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: JobCard(job: job, aiPriority: aiPriority),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
