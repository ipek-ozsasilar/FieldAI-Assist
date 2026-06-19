//Express’i projeye dahil ediyoruz. API endpoint yazmamızı sağlayacak.
const express = require("express");
//Flutter/web client backend’e istek atabilsin diye izin katmanı ekliyoruz.
const cors = require("cors");
const dotenv = require("dotenv");

dotenv.config();

const app = express();

app.use(cors());
//Backend’e JSON body geldiğinde okuyabilmemizi sağlar.
app.use(express.json());

//Ana test endpoint’i. Backend çalışıyor mu diye bakacağız.
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "FieldAI Assist Backend çalışıyor.",
  });
});

//Sağlık kontrol endpoint’i. Gerçek projelerde monitoring için kullanılır.
app.get("/health", (req, res) => {
  res.json({
    success: true,
    status: "ok",
    service: "fieldai-assist-backend",
  });
});

const port = process.env.PORT || 3000;

//Backend’i 3000 portunda başlatır.
app.listen(port, () => {
  console.log(`FieldAI Assist Backend ${port} portunda çalışıyor.`);
});