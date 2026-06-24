import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../jobs/models/ai_priority_model.dart';
import '../../../models/job.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, this.aiPriority, this.onOpen});

  final Job job;
  final AiJobPriority? aiPriority;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    if (job.isAiSuggestedPriority || aiPriority != null) {
      return _PriorityJobCard(job: job, aiPriority: aiPriority, onOpen: onOpen);
    }
    return _StandardJobCard(job: job, onOpen: onOpen);
  }
}

class _StandardJobCard extends StatelessWidget {
  const _StandardJobCard({required this.job, required this.onOpen});

  final Job job;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final isScheduled = job.status == JobStatus.scheduled;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                job.displayId,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              _StatusBadge(status: job.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            job.customerName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DetailColumn(
                  label: 'Device Model',
                  value: job.deviceModel,
                ),
              ),
              Expanded(
                child: _DetailColumn(
                  label: job.location != null ? 'Location' : 'Time',
                  value: job.location ?? job.time ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _OpenJobButton(outlined: isScheduled, onOpen: onOpen),
        ],
      ),
    );
  }
}

class _PriorityJobCard extends StatelessWidget {
  const _PriorityJobCard({
    required this.job,
    required this.aiPriority,
    required this.onOpen,
  });

  final Job job;
  final AiJobPriority? aiPriority;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final reason = aiPriority?.reason ?? job.reason;
    final suggestedAction = aiPriority?.suggestedAction;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.priorityCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: const Border(left: BorderSide(color: AppColors.teal, width: 4)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Icon(
              Icons.psychology_outlined,
              size: 48,
              color: AppColors.teal.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${job.displayId} • AI SUGGESTED PRIORITY',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.teal,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (aiPriority != null) ...[
                      _AiPriorityBadge(priority: aiPriority!.priority),
                      const SizedBox(width: 8),
                    ],
                    _StatusBadge(status: job.status),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  job.customerName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (reason != null && reason.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Reason: $reason',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (suggestedAction != null && suggestedAction.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Suggested Action: $suggestedAction',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _DetailColumn(
                        label: 'Device Model',
                        value: job.deviceModel,
                      ),
                    ),
                    Expanded(
                      child: _DetailColumn(
                        label: 'Issue',
                        value: job.issue ?? '',
                        valueColor: AppColors.urgentRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _OpenJobButton(outlined: false, onOpen: onOpen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiPriorityBadge extends StatelessWidget {
  const _AiPriorityBadge({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

Color getPriorityColor(String priority) {
  switch (priority) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    default:
      return Colors.green;
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final JobStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      JobStatus.inProgress => ('IN PROGRESS', AppColors.teal, AppColors.white),
      JobStatus.scheduled => (
        'SCHEDULED',
        AppColors.scheduledBadgeBg,
        AppColors.scheduledBadgeText,
      ),
      JobStatus.urgent => (
        'URGENT',
        AppColors.urgentBadgeBg,
        AppColors.urgentRed,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: fg,
        ),
      ),
    );
  }
}

class _DetailColumn extends StatelessWidget {
  const _DetailColumn({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _OpenJobButton extends StatelessWidget {
  const _OpenJobButton({required this.outlined, required this.onOpen});

  final bool outlined;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onOpen,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryNavy,
            side: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Open Job',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward, size: 18),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onOpen,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Open Job',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
