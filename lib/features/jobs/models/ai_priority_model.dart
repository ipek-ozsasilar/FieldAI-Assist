import '../../../models/job.dart';

class AiPriorityResult {
  final String summary;
  final List<AiJobPriority> priorities;
  final List<Job> jobs;

  AiPriorityResult({
    required this.summary,
    required this.priorities,
    this.jobs = const [],
  });

  factory AiPriorityResult.fromJson(Map<String, dynamic> json) {
    final prioritiesJson = json['priorities'] as List<dynamic>? ?? [];
    final jobsJson = json['jobs'] as List<dynamic>? ?? [];

    return AiPriorityResult(
      summary: json['summary'] ?? '',
      priorities: prioritiesJson
          .map((item) => AiJobPriority.fromJson(item as Map<String, dynamic>))
          .toList(),
      jobs: jobsJson
          .map((item) => Job.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AiJobPriority {
  final String jobId;
  final String priority;
  final String reason;
  final String suggestedAction;

  AiJobPriority({
    required this.jobId,
    required this.priority,
    required this.reason,
    required this.suggestedAction,
  });

  factory AiJobPriority.fromJson(Map<String, dynamic> json) {
    return AiJobPriority(
      jobId: json['jobId'] ?? '',
      priority: json['priority'] ?? 'low',
      reason: json['reason'] ?? '',
      suggestedAction: json['suggestedAction'] ?? '',
    );
  }
}
