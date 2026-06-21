//Bu backend’in ana giriş dosyası. Backend uygulamasını ayağa kaldıran dosya
//Express’i projeye dahil ediyoruz. API endpoint yazmamızı sağlayacak.
//Node.js’te başka bir paketi veya dosyayı kullanmak için require() kullanıyoruz.
const express = require("express");
//Flutter/web client backend’e istek atabilsin diye izin katmanı ekliyoruz.
const cors = require("cors");
const dotenv = require("dotenv");
const jobRoutes = require("./routes/jobRoutes");
const aiRoutes = require("./routes/aiRoutes");

dotenv.config();

//Express’e diyoruz ki: Bana bir backend uygulaması oluştur. Ben bunun üzerine endpointler ekleyeceğim.
const app = express();

app.use(cors());
//Backend’e JSON body geldiğinde okuyabilmemizi sağlar.
//Ara katman eklemek için kullanılır. İstek backend’e geldiğinde, endpoint’e ulaşmadan önce bazı işlemlerden geçsin.
app.use(express.json());

///api/jobs ile başlayan tüm istekleri jobRoutes.js dosyasına gönder. /api/jobs ile başlayan tüm istekleri
// jobRoutes.js dosyasına gönder. Mesela tarayıcıdan şunu açtın: http://localhost:3000/api/jobs/today
//Express bunu şöyle parçalar: /api/jobs  → server.js bunu yakalar /today     → jobRoutes.js içinde aranır
app.use("/api/jobs", jobRoutes);
app.use("/api/ai", aiRoutes);



const port = process.env.PORT || 3000;

//Backend’i 3000 portunda başlatır.
//Bu satır backend’i gerçekten başlatır. Yani bu olmazsa endpointleri yazsan bile server ayağa kalkmaz.
app.listen(port, () => {
  console.log(`FieldAI Assist Backend ${port} portunda çalışıyor.`);
});
