import '../../../models/job.dart';

abstract final class MockHomeData {
  static const technicianName = 'Ahmet Y.';
  static const dateLabel = 'Wednesday, Oct 25';
  static const activeJobCount = 4;

  static const aiInsightTitle = 'High-risk part detected';
  static const aiInsightBody =
      'Job #1004 requires specialized cooling tools.';

  static const jobs = <Job>[
    Job(
      id: '1001',
      customerName: 'Star Logistics',
      deviceModel: 'MX-200 Carrier',
      location: 'Warehouse B',
      status: JobStatus.inProgress,
    ),
    Job(
      id: '1002',
      customerName: 'Global Shipping',
      deviceModel: 'PT-100',
      time: '14:00 PM',
      status: JobStatus.scheduled,
    ),
    Job(
      id: '1003',
      customerName: 'Apex Distribution',
      deviceModel: 'CF-400',
      time: '10:00 AM',
      status: JobStatus.scheduled,
    ),
    Job(
      id: '1004',
      customerName: 'Zenith Logistics',
      deviceModel: 'K-900 Heavy Lift',
      issue: 'Hydraulic Failure',
      reason:
          'Similar hydraulic failures caused significant downtime in recent warehouse jobs.',
      status: JobStatus.urgent,
      isAiSuggestedPriority: true,
    ),
  ];
}
