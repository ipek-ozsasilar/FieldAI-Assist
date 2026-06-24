import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../home/widgets/app_bottom_nav.dart';
import 'models/job_detail_model.dart';
import 'services/job_api_service.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final JobApiService _service = JobApiService();
  late Future<JobDetail> _jobFuture;

  @override
  void initState() {
    super.initState();
    _jobFuture = _service.getJobDetail(widget.jobId);
  }

  Future<void> _refresh() async {
    setState(() {
      _jobFuture = _service.getJobDetail(widget.jobId);
    });
    await _jobFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JobDetail>(
      future: _jobFuture,
      builder: (context, snapshot) {
        final title = snapshot.data?.displayId ?? _displayJobId(widget.jobId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _JobDetailAppBar(title: title),
          bottomNavigationBar: AppBottomNav(
            selectedTab: HomeTab.aiAssist,
            onTabSelected: (tab) {
              if (tab == HomeTab.home) {
                Navigator.of(context).pop();
              }
            },
          ),
          body: switch (snapshot.connectionState) {
            ConnectionState.waiting => const Center(
              child: CircularProgressIndicator(),
            ),
            _ when snapshot.hasError => _JobDetailError(
              error: snapshot.error,
              onRetry: _refresh,
            ),
            _ => RefreshIndicator(
              onRefresh: _refresh,
              child: _JobDetailContent(job: snapshot.data!),
            ),
          },
        );
      },
    );
  }

  String _displayJobId(String jobId) {
    return jobId.toUpperCase().startsWith('JOB-') ? jobId : 'JOB-$jobId';
  }
}

class _JobDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _JobDetailAppBar({required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, size: 28),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: AppColors.primaryNavy,
            size: 30,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.navSelectedBg,
            child: Text(
              'JD',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _JobDetailError extends StatelessWidget {
  const _JobDetailError({required this.error, required this.onRetry});

  final Object? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.urgentRed,
              size: 42,
            ),
            const SizedBox(height: 12),
            const Text(
              'Job detail could not be loaded.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _JobDetailContent extends StatelessWidget {
  const _JobDetailContent({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        _HeroCard(job: job),
        const SizedBox(height: 16),
        _DeviceCards(job: job),
        const SizedBox(height: 18),
        _IssueSummaryCard(job: job),
        const SizedBox(height: 20),
        _ServiceHistorySection(job: job),
        _ArchivedPhotoCard(job: job),
        _DocumentsSection(job: job),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    final priority = job.aiPriority?.toUpperCase() ?? 'AI PENDING';

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF171820),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -2,
            top: -4,
            child: Icon(
              Icons.precision_manufacturing_outlined,
              size: 96,
              color: AppColors.white.withValues(alpha: 0.22),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PriorityPill(label: priority),
              const SizedBox(height: 16),
              Text(
                job.title.isEmpty ? 'Service Job' : job.title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                job.location.isEmpty
                    ? 'Field Diagnostic Required'
                    : job.location,
                style: const TextStyle(
                  color: Color(0xFFD8DAE5),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AI diagnosis will be connected next.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.psychology_outlined, size: 26),
                  label: const Text('Start AI Diagnosis'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  const _PriorityPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isCritical = label.contains('HIGH') || label.contains('CRITICAL');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isCritical ? AppColors.urgentRed : AppColors.teal,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        isCritical ? 'CRITICAL PRIORITY' : label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _DeviceCards extends StatelessWidget {
  const _DeviceCards({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            title: 'DEVICE MODEL',
            value: job.device.model ?? 'N/A',
            icon: Icons.devices_other_outlined,
            iconAlignment: Alignment.bottomRight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _InfoTile(
            title: 'SERIAL NUMBER',
            value: job.device.serialNumber ?? 'N/A',
            icon: Icons.qr_code_2_outlined,
            iconAlignment: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconAlignment,
  });

  final String title;
  final String value;
  final IconData icon;
  final Alignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Stack(
        children: [
          Align(
            alignment: iconAlignment,
            child: Icon(icon, color: const Color(0xFFC3C6D7), size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 25,
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IssueSummaryCard extends StatelessWidget {
  const _IssueSummaryCard({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    final errorCode = job.issue.errorCode ?? job.errorCode;
    final summary = job.issue.summary ?? job.title;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF21C3DF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF0C3140)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Issue Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0C3140),
                  ),
                ),
              ),
              if (errorCode != null && errorCode.isNotEmpty)
                _ErrorCodeBadge(errorCode: errorCode),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            "'$summary'",
            style: const TextStyle(
              fontSize: 23,
              height: 1.55,
              color: AppColors.textPrimary,
              letterSpacing: 0,
            ),
          ),
          const Divider(height: 34, color: AppColors.cardBorder),
          Wrap(
            spacing: 22,
            runSpacing: 10,
            children: [
              _IssueMetric(
                icon: Icons.history,
                label: 'Last Error: ${_relativeTime(job.createdAt)}',
              ),
              if (job.issue.temperature != null)
                _IssueMetric(
                  icon: Icons.device_thermostat,
                  label: 'Temp: ${job.issue.temperature}',
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _relativeTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'N/A';
    }

    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }

    final diff = DateTime.now().difference(parsed);
    if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    }
    if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    }
    return '${diff.inMinutes.clamp(1, 59)}m ago';
  }
}

class _ErrorCodeBadge extends StatelessWidget {
  const _ErrorCodeBadge({required this.errorCode});

  final String errorCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF006D77),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$errorCode DETECTED',
        style: const TextStyle(
          color: Color(0xFF7DD3E0),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _IssueMetric extends StatelessWidget {
  const _IssueMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _ServiceHistorySection extends StatelessWidget {
  const _ServiceHistorySection({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    if (job.serviceHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final item = job.serviceHistory.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('SERVICE HISTORY'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.navSelectedBg,
                ),
                child: const Icon(Icons.history, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.note,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFC3C6D7)),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ArchivedPhotoCard extends StatelessWidget {
  const _ArchivedPhotoCard({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    final photo = job.archivedPhoto;

    if (photo == null || photo.url.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 265,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                photo.url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    color: AppColors.cardBorder,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF10131A),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.white,
                      size: 44,
                    ),
                  );
                },
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Text(
                  photo.caption ?? 'Archived maintenance photo',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({required this.job});

  final JobDetail job;

  @override
  Widget build(BuildContext context) {
    if (job.documents.isEmpty) {
      return const SizedBox.shrink();
    }

    final docs = job.documents.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('DOCUMENTATION'),
        const SizedBox(height: 14),
        Row(
          children: [
            for (var index = 0; index < docs.length; index++) ...[
              Expanded(child: _DocumentTile(document: docs[index])),
              if (index != docs.length - 1) const SizedBox(width: 16),
            ],
          ],
        ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});

  static const _documentOpener = MethodChannel(
    'fieldai_assist/document_opener',
  );

  final JobDocument document;

  Future<void> _openDocument(BuildContext context) async {
    if (document.url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Document URL is empty.')));
      return;
    }

    debugPrint('Opening document: ${document.title}');
    debugPrint('URL: ${document.url}');

    try {
      final opened = await _documentOpener.invokeMethod<bool>('openUrl', {
        'url': document.url,
      });

      if (opened != true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document could not be opened.')),
        );
      }
    } on PlatformException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Document could not be opened.'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Document open error: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSafety = document.type.toLowerCase().contains('safety');

    return InkWell(
      onTap: () => _openDocument(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 124,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC7CBDA)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSafety ? Icons.health_and_safety_outlined : Icons.menu_book,
              color: isSafety ? AppColors.urgentRed : AppColors.primaryNavy,
              size: 34,
            ),
            const SizedBox(height: 14),
            Text(
              document.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 17,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    );
  }
}
