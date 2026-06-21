//Bu ne yapıyor? Controller, HTTP isteğiyle ilgilenir. Yani: Request geldi. Service’i çağır.
//Başarılıysa JSON dön. Hata varsa standart hata response’u dön.
const jobService = require("../services/jobService");

async function getTodayJobs(req, res) {
  try {
    const jobs = await jobService.getTodayJobs();

    return res.json({
      success: true,
      jobs,
    });
  } catch (error) {
    console.error("GET /api/jobs/today error:", error);

    return res.status(500).json({
      success: false,
      errorCode: "JOBS_FETCH_FAILED",
      message: "Bugünkü servis işleri alınamadı.",
    });
  }
}

module.exports = {
  getTodayJobs,
};