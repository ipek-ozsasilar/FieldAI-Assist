//Bu dosya endpoint adresini tanımlar.
const express = require("express");
const jobController = require("../controllers/jobController");

//express.Router() küçük bir mini endpoint kutusu oluşturur.
//Yani server.js içine bütün endpointleri yazmak yerine, jobs ile ilgili endpointleri ayrı bir kutuya koyuyoruz.
const router = express.Router();

///today adresine GET isteği gelirse express jobController.getTodayJobs fonksiyonunu çalıştır.
//Sen burada fonksiyonu çağırmıyorsun, Express’e teslim ediyorsun. Express, /today adresine GET isteği gelirse
//bu fonksiyonu sen çağır. O yüzden parametreler yok mesela suan fonksıyon ıcınde 
//Express req ve res’i HTTP isteği geldiği anda Node.js’in kendi HTTP sistemi üzerinden alıyor.

// Bugünkü işler.
// Örnek: GET /api/jobs/today
router.get("/today", jobController.getTodayJobs);
// Job detail.
// Örnek: GET /api/jobs/JOB-1011
router.get("/:jobId", jobController.getJobDetail);

module.exports = router;