//Bu dosya endpoint adresini tanımlar.
const express = require("express");
const jobController = require("../controllers/jobController");

//express.Router() küçük bir mini endpoint kutusu oluşturur.
//Yani server.js içine bütün endpointleri yazmak yerine, jobs ile ilgili endpointleri ayrı bir kutuya koyuyoruz.
const router = express.Router();

///today adresine GET isteği gelirse jobController.getTodayJobs fonksiyonunu çalıştır.
router.get("/today", jobController.getTodayJobs);

module.exports = router;