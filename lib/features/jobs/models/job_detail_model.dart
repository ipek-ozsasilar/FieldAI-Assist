class JobDetailResponse {
  const JobDetailResponse({required this.success, required this.job});

  final bool success;
  final JobDetail job;

  factory JobDetailResponse.fromJson(Map<String, dynamic> json) {
    return JobDetailResponse(
      success: json['success'] == true,
      job: JobDetail.fromJson(json['job'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class JobDetail {
  const JobDetail({
    required this.id,
    required this.customerName,
    required this.location,
    required this.title,
    required this.errorCode,
    required this.status,
    required this.scheduledDate,
    required this.createdAt,
    required this.technicianName,
    required this.technicianRegion,
    required this.aiPriority,
    required this.device,
    required this.issue,
    required this.serviceHistory,
    required this.archivedPhoto,
    required this.documents,
  });

  final String id;
  final String customerName;
  final String location;
  final String title;
  final String? errorCode;
  final String status;
  final String? scheduledDate;
  final String? createdAt;
  final String? technicianName;
  final String? technicianRegion;
  final String? aiPriority;
  final JobDevice device;
  final JobIssue issue;
  final List<ServiceHistoryItem> serviceHistory;
  final ArchivedPhoto? archivedPhoto;
  final List<JobDocument> documents;

  String get displayId => id.toUpperCase().startsWith('JOB-') ? id : 'JOB-$id';

  factory JobDetail.fromJson(Map<String, dynamic> json) {
    return JobDetail(
      id: '${json['id'] ?? ''}',
      customerName: json['customerName'] ?? '',
      location: json['location'] ?? '',
      title: json['title'] ?? '',
      errorCode: json['errorCode'],
      status: json['status'] ?? '',
      scheduledDate: json['scheduledDate'],
      createdAt: json['createdAt'],
      technicianName: json['technicianName'],
      technicianRegion: json['technicianRegion'],
      aiPriority: json['aiPriority'],
      device: JobDevice.fromJson(json['device'] as Map<String, dynamic>? ?? {}),
      issue: JobIssue.fromJson(json['issue'] as Map<String, dynamic>? ?? {}),
      serviceHistory: (json['serviceHistory'] as List<dynamic>? ?? [])
          .map(
            (item) => ServiceHistoryItem.fromJson(
              item as Map<String, dynamic>? ?? {},
            ),
          )
          .toList(),
      archivedPhoto: json['archivedPhoto'] == null
          ? null
          : ArchivedPhoto.fromJson(
              json['archivedPhoto'] as Map<String, dynamic>? ?? {},
            ),
      documents: (json['documents'] as List<dynamic>? ?? [])
          .map(
            (item) => JobDocument.fromJson(item as Map<String, dynamic>? ?? {}),
          )
          .toList(),
    );
  }
}

class JobDevice {
  const JobDevice({
    required this.id,
    required this.model,
    required this.type,
    required this.manufacturer,
    required this.serialNumber,
  });

  final int? id;
  final String? model;
  final String? type;
  final String? manufacturer;
  final String? serialNumber;

  factory JobDevice.fromJson(Map<String, dynamic> json) {
    return JobDevice(
      id: json['id'],
      model: json['model'],
      type: json['type'],
      manufacturer: json['manufacturer'],
      serialNumber: json['serialNumber'],
    );
  }
}

class JobIssue {
  const JobIssue({
    required this.title,
    required this.errorCode,
    required this.summary,
    required this.temperature,
  });

  final String? title;
  final String? errorCode;
  final String? summary;
  final String? temperature;

  factory JobIssue.fromJson(Map<String, dynamic> json) {
    return JobIssue(
      title: json['title'],
      errorCode: json['errorCode'],
      summary: json['summary'],
      temperature: json['temperature'],
    );
  }
}

class ServiceHistoryItem {
  const ServiceHistoryItem({
    required this.id,
    required this.title,
    required this.note,
    required this.performedBy,
    required this.performedAt,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String note;
  final String? performedBy;
  final String? performedAt;
  final String? createdAt;

  factory ServiceHistoryItem.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      performedBy: json['performedBy'],
      performedAt: json['performedAt'],
      createdAt: json['createdAt'],
    );
  }
}

class ArchivedPhoto {
  const ArchivedPhoto({
    required this.id,
    required this.caption,
    required this.sourceType,
    required this.storageProvider,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.url,
    required this.expiresInSeconds,
  });

  final int id;
  final String? caption;
  final String? sourceType;
  final String? storageProvider;
  final String? mimeType;
  final int? fileSizeBytes;
  final String url;
  final int? expiresInSeconds;

  factory ArchivedPhoto.fromJson(Map<String, dynamic> json) {
    return ArchivedPhoto(
      id: json['id'] ?? 0,
      caption: json['caption'],
      sourceType: json['sourceType'],
      storageProvider: json['storageProvider'],
      mimeType: json['mimeType'],
      fileSizeBytes: json['fileSizeBytes'],
      url: json['url'] ?? '',
      expiresInSeconds: json['expiresInSeconds'],
    );
  }
}

class JobDocument {
  const JobDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.deviceModel,
    required this.fileName,
    required this.mimeType,
    required this.storageProvider,
    required this.version,
    required this.fileSizeBytes,
    required this.checksum,
    required this.url,
    required this.expiresInSeconds,
  });

  final String id;
  final String title;
  final String type;
  final String? deviceModel;
  final String? fileName;
  final String? mimeType;
  final String? storageProvider;
  final String? version;
  final int? fileSizeBytes;
  final String? checksum;
  final String url;
  final int? expiresInSeconds;

  factory JobDocument.fromJson(Map<String, dynamic> json) {
    return JobDocument(
      id: '${json['id'] ?? ''}',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      deviceModel: json['deviceModel'],
      fileName: json['fileName'],
      mimeType: json['mimeType'],
      storageProvider: json['storageProvider'],
      version: json['version'],
      fileSizeBytes: json['fileSizeBytes'],
      checksum: json['checksum'],
      url: json['url'] ?? '',
      expiresInSeconds: json['expiresInSeconds'],
    );
  }
}
