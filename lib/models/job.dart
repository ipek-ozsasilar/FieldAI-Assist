enum JobStatus { inProgress, scheduled, urgent }

class Job {
  const Job({
    required this.id,
    required this.customerName,
    required this.deviceModel,
    required this.status,
    this.location,
    this.time,
    this.issue,
    this.reason,
    this.isAiSuggestedPriority = false,
  });

  final String id;
  final String customerName;
  final String deviceModel;
  final JobStatus status;
  final String? location;
  final String? time;
  final String? issue;
  final String? reason;
  final bool isAiSuggestedPriority;

  String get displayId => 'JOB-$id';
}
