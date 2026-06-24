//Bu ne yapıyor? Controller, HTTP isteğiyle ilgilenir. Yani: Request geldi. Service’i çağır.
//Başarılıysa JSON dön. Hata varsa standart hata response’u dön.
const jobService = require("../services/jobService");

//res, HTTP isteğine cevap göndermek için Express’in verdiği response nesnesidir.
//res = Backend’den client’a gönderilecek HTTP cevap aracı
//req bir nesnedir. İçinde isteğin bilgileri vardır. console.log(req.method); // "GET"
//res, client’a cevap göndermek için Express’in verdiği araç.
/*  res = {
  json: function(...) {},
  status: function(...) {},
  send: function(...) {}
}*/
async function getTodayJobs(req, res) {
  try {
    const jobs = await jobService.getTodayJobs();

    return res.json({
      success: true,
      jobs,
    });
  } catch (error) {
    console.error("GET /api/jobs/today error:", error);
    
    //500 şu demek: Backend tarafında beklenmeyen hata oluştu.
    return res.status(500).json({
      success: false,
      errorCode: "JOBS_FETCH_FAILED",
      message: "Bugünkü servis işleri alınamadı.",
    });
  }
}

async function getJobDetail(req, res) {
  try {
    const { jobId } = req.params;

    const job = await jobService.getJobDetail(jobId);

    if (!job) {
      return res.status(404).json({
        success: false,
        errorCode: "JOB_NOT_FOUND",
        message: "Servis işi bulunamadı.",
      });
    }

    return res.json({
      success: true,
      job,
    });
  } catch (error) {
    console.error("GET /api/jobs/:jobId error:", error);

    return res.status(500).json({
      success: false,
      errorCode: "JOB_DETAIL_FETCH_FAILED",
      message: "Servis işi detayı alınamadı.",
      detail: error.message,
    });
  }
}

module.exports = {
  getTodayJobs,
  getJobDetail,
};