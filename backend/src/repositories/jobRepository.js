//SQL sorgularını yönetir
//Bu dosya sadece DB sorgusundan sorumlu.
const pool = require("../config/db");
//Bugün planlanmış servis işlerini getirir.
async function getTodayJobs() {
  const query = `
    SELECT
      service_jobs.id,
      service_jobs.customer_name,
      service_jobs.location,
      service_jobs.issue_title,
      service_jobs.error_code,
      service_jobs.status,
      service_jobs.scheduled_date,
      devices.model AS device_model,
      devices.device_type,
      technicians.name AS technician_name
    FROM service_jobs
    JOIN devices ON service_jobs.device_id = devices.id
    JOIN technicians ON service_jobs.technician_id = technicians.id
    WHERE service_jobs.scheduled_date = CURRENT_DATE
    ORDER BY service_jobs.created_at DESC;
  `;

  const result = await pool.query(query);
  //Sadece satırları döndürüyoruz
  return result.rows;
}

// Job detail ana bilgilerini getirir.
async function getJobById(jobId) {
  const query = `
    SELECT
      service_jobs.id,
      service_jobs.customer_name,
      service_jobs.location,
      service_jobs.issue_title,
      service_jobs.error_code,
      service_jobs.status,
      service_jobs.scheduled_date,
      service_jobs.created_at,
      service_jobs.device_id,

      devices.model AS device_model,
      devices.device_type,
      devices.manufacturer AS device_manufacturer,

      technicians.name AS technician_name,
      technicians.region AS technician_region
    FROM service_jobs
    LEFT JOIN devices ON service_jobs.device_id = devices.id
    LEFT JOIN technicians ON service_jobs.technician_id = technicians.id
    WHERE service_jobs.id = $1
    LIMIT 1;
  `;

  const result = await pool.query(query, [jobId]);
  return result.rows[0] || null;
}

// Job'a ait servis geçmişini getirir.
async function getServiceHistoryByJobId(jobId) {
  const query = `
    SELECT
      id,
      title,
      note,
      performed_by,
      performed_at,
      created_at
    FROM service_history
    WHERE job_id = $1
    ORDER BY performed_at DESC;
  `;

  const result = await pool.query(query, [jobId]);
  return result.rows;
}

// Job'a ait son arşiv fotoğrafını getirir.
async function getLatestPhotoByJobId(jobId) {
  const query = `
    SELECT
      id,
      caption,
      source_type,
      storage_provider,
      bucket_name,
      object_key,
      public_url,
      mime_type,
      file_size_bytes,
      created_at
    FROM job_photos
    WHERE job_id = $1
    ORDER BY created_at DESC
    LIMIT 1;
  `;

  const result = await pool.query(query, [jobId]);
  return result.rows[0] || null;
}

// Job'a bağlı dokümanları getirir.
async function getDocumentsByJobId(jobId) {
  const query = `
    SELECT
      documents.id,
      documents.title,
      documents.document_type,
      documents.device_model,
      documents.file_name,
      documents.mime_type,
      documents.storage_provider,
      documents.bucket_name,
      documents.object_key,
      documents.public_url,
      documents.version,
      documents.file_size_bytes,
      documents.checksum,
      documents.created_at
    FROM job_documents
    JOIN documents ON documents.id = job_documents.document_id
    WHERE job_documents.job_id = $1
    ORDER BY documents.document_type ASC, documents.title ASC;
  `;

  const result = await pool.query(query, [jobId]);
  return result.rows;
}

//Fonksiyonu dışarı açıyoruz
module.exports = {
  getTodayJobs,
  getJobById,
  getServiceHistoryByJobId,
  getLatestPhotoByJobId,
  getDocumentsByJobId,
};