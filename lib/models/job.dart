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

  String get displayId => id.toUpperCase().startsWith('JOB-') ? id : 'JOB-$id';

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: '${json['id'] ?? ''}',
      customerName: json['customerName'] ?? json['customer_name'] ?? '',
      deviceModel: json['deviceModel'] ?? json['device_model'] ?? '',
      location: json['location'],
      time: json['scheduledDate'] ?? json['scheduled_date'],
      issue: json['issueTitle'] ?? json['issue_title'],
      status: _parseStatus(json['status']),
    );
  }

  static JobStatus _parseStatus(dynamic value) {
    final status = '${value ?? ''}'.toLowerCase().replaceAll('-', '_');

    if (status.contains('urgent')) {
      return JobStatus.urgent;
    }

    if (status.contains('progress')) {
      return JobStatus.inProgress;
    }

    return JobStatus.scheduled;
  }
}
