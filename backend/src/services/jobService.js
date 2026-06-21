//Bu service katmanı DB formatını mobil uygulamaya uygun formata çeviriyor.
//Bu dosya iş mantığı ile ilgilenir
const jobRepository = require("../repositories/jobRepository");

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

module.exports = {
  getTodayJobs,
};