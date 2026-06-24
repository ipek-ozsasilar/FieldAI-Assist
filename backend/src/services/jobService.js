//Bu service katmanı DB formatını mobil uygulamaya uygun formata çeviriyor.
//Bu dosya iş mantığı ile ilgilenir
const jobRepository = require("../repositories/jobRepository");
const storageService = require("./storage.service");

//Job verisimi çeker
async function getTodayJobs() {
  const jobs = await jobRepository.getTodayJobs();

  //DB formatını mobil uygulamaya uygun formata çeviriyor.
  return jobs.map((job) => ({
    id: job.id,
    customerName: job.customer_name,
    location: job.location,
    issueTitle: job.issue_title,
    errorCode: job.error_code,
    status: job.status,
    scheduledDate: job.scheduled_date,
    deviceModel: job.device_model,
    deviceType: job.device_type,
    technicianName: job.technician_name,
  }));
}

// Job detail verisini hazırlar.
async function getJobDetail(jobId) {
  const expiresInSeconds = Number(process.env.SIGNED_URL_EXPIRES_IN || 3600);

  const job = await jobRepository.getJobById(jobId);

  if (!job) {
    return null;
  }

  const serviceHistoryRows = await jobRepository.getServiceHistoryByJobId(jobId);
  const photoRow = await jobRepository.getLatestPhotoByJobId(jobId);
  const documentRows = await jobRepository.getDocumentsByJobId(jobId);

  let archivedPhoto = null;

  if (photoRow) {
    const signedUrl = await storageService.createStorageSignedUrl({
      bucketName: photoRow.bucket_name,
      objectKey: photoRow.object_key,
      expiresInSeconds,
    });

    archivedPhoto = {
      id: photoRow.id,
      caption: photoRow.caption,
      sourceType: photoRow.source_type,
      storageProvider: photoRow.storage_provider,
      mimeType: photoRow.mime_type,
      fileSizeBytes: photoRow.file_size_bytes,
      url: signedUrl,
      expiresInSeconds,
    };
  }

  const documents = await Promise.all(
    documentRows.map(async (doc) => {
      const signedUrl = await storageService.createStorageSignedUrl({
        bucketName: doc.bucket_name,
        objectKey: doc.object_key,
        expiresInSeconds,
      });

      return {
        id: doc.id,
        title: doc.title,
        type: doc.document_type,
        deviceModel: doc.device_model,
        fileName: doc.file_name,
        mimeType: doc.mime_type,
        storageProvider: doc.storage_provider,
        version: doc.version,
        fileSizeBytes: doc.file_size_bytes,
        checksum: doc.checksum,
        url: signedUrl,
        expiresInSeconds,
      };
    })
  );

  return {
    id: job.id,
    customerName: job.customer_name,
    location: job.location,
  
    title: job.issue_title,
    errorCode: job.error_code,
    status: job.status,
    scheduledDate: job.scheduled_date,
    createdAt: job.created_at,
  
    technicianName: job.technician_name,
    technicianRegion: job.technician_region,
  
    // Bu değer DB'den gelmiyor.
    // İleride AI priority endpoint'i ayrıca hesaplayacak.
    aiPriority: null,
  
    device: {
      id: job.device_id,
      model: job.device_model,
      type: job.device_type,
      manufacturer: job.device_manufacturer,
  
      // Şu an devices tablosunda serial_number yok.
      serialNumber: null,
    },
  
    issue: {
      title: job.issue_title,
      errorCode: job.error_code,
  
      // Şu an service_jobs tablosunda issue_summary yok.
      // MVP'de issue_title üzerinden gösterebiliriz.
      summary: job.issue_title,
  
      // Şu an DB'de temperature yok.
      temperature: null,
    },
  
    serviceHistory: serviceHistoryRows.map((item) => ({
      id: item.id,
      title: item.title,
      note: item.note,
      performedBy: item.performed_by,
      performedAt: item.performed_at,
      createdAt: item.created_at,
    })),
  
    archivedPhoto,
    documents,
  };
}

module.exports = {
  getTodayJobs,
  getJobDetail,
};