//DB verisini AI’a context olarak verip structured output alıyoruz.
//zod, gelen verinin beklediğimiz formata uyup uymadığını kontrol eden validation kütüphanesi.
const { z } = require("zod");
const openai = require("../config/openaiClient");

//AI’dan beklediğimiz JSON formatını tanımlıyoruz
/*
I cevabı şöyle bir obje olmalı:

{
  "summary": "string",
  "priorities": [
    {
      "jobId": "string",
      "priority": "high | medium | low",
      "reason": "string",
      "suggestedAction": "string"
    }
  ]
}
*/
const AiJobPrioritySchema = z.object({
  summary: z.string(),
  priorities: z.array(
    z.object({
      jobId: z.string(),
      priority: z.enum(["high", "medium", "low"]),
      reason: z.string(),
      suggestedAction: z.string(),
    })
  ),
});

//structured outputu suan prompt ıcınde belırtıp ıstıyoruz
async function prioritizeTodayJobs(jobs) {
  if (!jobs || jobs.length === 0) {
    return {
      summary: "Bugün için önceliklendirilecek servis işi bulunamadı.",
      priorities: [],
    };
  }

  const prompt = `
Sen FieldAI Assist uygulamasında çalışan bir saha servis AI asistanısın.

Görevin:
Bugünkü servis işlerini analiz et ve her iş için öncelik öner.

Çok önemli kurallar:
- Sadece verilen jobs verisini kullan.
- Uydurma müşteri, cihaz, hata kodu veya geçmiş bilgi ekleme.
- Eğer veri yoksa tahmin üretme.
- Kritik görünen hata kodlarını, endüstriyel cihazları, hidrolik basınç problemlerini, soğutma performansı düşüşlerini daha riskli değerlendir.
- Cevabı SADECE valid JSON olarak dön.
- Markdown kullanma.
- JSON dışında açıklama yazma.

Beklenen JSON formatı:
{
  "summary": "Bugünkü işlerin kısa genel değerlendirmesi",
  "priorities": [
    {
      "jobId": "JOB-1001",
      "priority": "high",
      "reason": "Bu iş neden bu öncelikte?",
      "suggestedAction": "Teknisyenin ilk yapması gereken önerilen aksiyon"
    }
  ]
}

Bugünkü servis işleri:
${JSON.stringify(jobs, null, 2)}
`;
// ${JSON.stringify(jobs, null, 2)} Bu satır jobs array’ini okunabilir JSON metnine çevirip prompt içine koyuyor. 
//Yani jobs verisini prompt’un içine koyup modele gönderdiğimiz anda AI’a context vermiş oluyoruz.

  //Burada OpenAI’ye istek atıyorsun.
  const response = await openai.responses.create({
    model: "gpt-4.1-mini",
    input: prompt,
  });
  //AI cevabını text olarak alıyoruz
  const rawText = response.output_text;
  //Burada birazdan JSON parse sonucunu tutacak değişkeni hazırlıyoruz.
  let parsed;

  try {
    //JSON.parse ile metni objeye çeviriyoruz Bu dışarıdan bakınca JSON gibi görünüyor ama JavaScript için hâlâ düz yazı/metin.
    //rawText string olduğu için bunu JavaScript objesine çevirmemiz gerekiyor.
    parsed = JSON.parse(rawText);
  }
  //Ama AI bazen JSON dışında metin dönerse: Bu valid JSON değildir. O zaman JSON.parse hata verir. Sen de bunu yakalıyorsun.
  catch (error) {
    console.error("AI JSON parse error. Raw output:", rawText);
    throw new Error("AI_PRIORITY_INVALID_JSON");
  }
  //Burada parse edilmiş JSON’un gerçekten beklenen schema’ya uyup uymadığını kontrol ediyoruz. Structed Output valıdatıon edıyoruz
  const validated = AiJobPrioritySchema.parse(parsed);
  // Hata olursa validated oluşmaz. Böylece return validatd dönmez.
  return validated;
}

module.exports = {
  prioritizeTodayJobs,
};