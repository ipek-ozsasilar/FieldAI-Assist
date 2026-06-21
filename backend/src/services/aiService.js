const { z } = require("zod");
const openai = require("../config/openaiClient");

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

  const response = await openai.responses.create({
    model: "gpt-4.1-mini",
    input: prompt,
  });

  const rawText = response.output_text;

  let parsed;

  try {
    parsed = JSON.parse(rawText);
  } catch (error) {
    console.error("AI JSON parse error. Raw output:", rawText);
    throw new Error("AI_PRIORITY_INVALID_JSON");
  }

  const validated = AiJobPrioritySchema.parse(parsed);

  return validated;
}

module.exports = {
  prioritizeTodayJobs,
};