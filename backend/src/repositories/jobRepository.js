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

//Fonksiyonu dışarı açıyoruz
module.exports = {
  getTodayJobs,
};