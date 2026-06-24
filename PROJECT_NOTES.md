# FieldAI Assist - Project Notes

## Amaç

FieldAI Assist, saha servis teknisyenleri için geliştirilen AI destekli mobil asistandır.

Ana hedef:
- Teknisyen bugünkü servis işlerini mobil uygulamada görür.
- AI, bugünkü işleri risk/öncelik açısından analiz eder.
- Teknisyen job detail ekranından AI diagnosis alır.
- İleride RAG ile teknik dokümanlardan kaynaklı cevap üretilecek.
- AI çıktıları structured formatta alınacak ve backend tarafında validate edilecek.
- Kritik işlemler kullanıcı onayı olmadan DB’ye yazılmayacak.

## Projenin AI Odaklı Amacı

Bu proje sadece bir mobil saha servis uygulaması değildir.

Ana amaç, gerçek bir mobil ürün üzerinde modern AI ürün geliştirme kavramlarını uygulamaktır.

Bu projede öğrenilecek ve uygulanacak AI konuları:

- Backend üzerinden güvenli LLM API kullanımı
- OpenAI API bağlantısı
- AI'a gerçek database verisini context olarak verme
- Structured output alma
- Zod ile AI çıktısını validate etme
- AI cevabını mobil uygulamada ürün aksiyonuna dönüştürme
- RAG mimarisine hazırlanma
- Embedding mantığını öğrenme
- pgvector ile vector search yapmaya hazırlanma
- Tool calling / controlled action mantığı
- Kullanıcı onayı gerektiren kritik işlemler
- AI request logging
- Token, latency ve cost tracking
- Prompt injection risklerine karşı güvenli mimari
- Data leakage risklerine karşı backend merkezli tasarım
- AI hallucination azaltma
- Kaynaklı cevap üretme
- Evals ile AI kalite ölçümüne hazırlanma

Bu yüzden proje sadece UI geliştirme projesi değildir.

Bu proje:

Flutter Mobile App  
↓  
Node.js Backend  
↓  
PostgreSQL  
↓  
OpenAI API  
↓  
İleride RAG / pgvector / AI logs / security  

mantığıyla geliştirilen AI destekli ürün mimarisi portföy projesidir.

## Kullanıcı Rolleri

### Admin / Operasyon

Admin veya operasyon kullanıcısı servis işlerini sisteme girer.

Sorumlulukları:
- Servis işi oluşturur.
- Teknisyen seçer.
- Cihaz seçer.
- Tarih belirler.
- İşin müşteri ve lokasyon bilgisini girer.

Admin ekranı MVP sonunda yapılacaktır.

### Teknisyen

Teknisyen mobil uygulamanın ana kullanıcısıdır.

Sorumlulukları:
- Kendisine atanmış işleri görür.
- AI priority önerisi alır.
- Job detail ekranını açar.
- AI diagnosis alır.
- Servis notu oluşturur.
- İşi tamamlar.

İlk geliştirme odağı teknisyen deneyimidir.

## Genel Mimari

Local development mimarisi:

Flutter Mobile App  
↓  
Node.js Express Backend  
↓  
PostgreSQL  
↓  
OpenAI API  

Backend API keyleri ve DB şifreleri Flutter içinde tutulmaz.

Gizli bilgiler backend tarafında tutulur:

- OPENAI_API_KEY
- DATABASE_URL

Bu bilgiler `backend/.env` içinde durur.

`.env` dosyası GitHub’a gönderilmez.

## Local Development Çalışma Mantığı

Projeyi localde çalıştırırken üç ana parça vardır:

1. PostgreSQL server
2. Node.js backend
3. Flutter mobile app

Başlatma sırası:

1. PostgreSQL başlatılır.
2. Backend ayağa kaldırılır.
3. Flutter uygulama çalıştırılır.

## .bat Dosyası Notu

Windows’ta PostgreSQL’i her seferinde uzun komut yazarak başlatmamak için `.bat` dosyası oluşturuldu.

`.bat` dosyası Windows komut dosyasıdır.

Exe değildir ama çift tıklayınca terminal komutlarını sırayla çalıştırır.

Bizim `.bat` dosyamız PostgreSQL server’ı başlatmak için kullanılır.

Örnek içerik:

```bat
@echo off
"C:\Program Files\PostgreSQL\18\bin\pg_ctl.exe" start -D "C:\Users\HP\postgres-data"
pause

Bu ekranlar projede neyi temsil ediyor?

Paylaştığın UI’lar aslında ileride öğreneceğimiz konular için çok güzel ürün karşılığı oluşturuyor.

1. Home ekranı

Buradaki:

AI INSIGHT
High-risk part detected
Job #1004 requires specialized cooling tools.

şu konulara bağlanacak:

AI job prioritization
structured output
risk scoring
AI summary
backend üzerinden güvenli LLM çağrısı

Burada AI sadece metin üretmeyecek. Backend şuna benzer structured data dönecek:

{
  "summary": "High-risk part detected",
  "highlightedJobId": "JOB-1004",
  "priority": "high",
  "reason": "Similar hydraulic failures caused downtime in recent warehouse jobs."
}

Flutter bunu karta, badge’e ve uyarıya çevirecek.

2. Job detail ekranı

Buradaki:

Start AI Diagnosis
Device Model
Serial Number
Issue Summary
Service History
Documentation

ileride şu konulara bağlanacak:

RAG
embedding
vector database
source citation
job diagnosis
technical document retrieval

Yani AI diagnosis yaparken sadece prompt’a güvenmeyeceğiz.

Akış şöyle olacak:

Job detail data
↓
Device model + error code + issue summary
↓
Embedding search
↓
Vector database içinde ilgili manual/chunk bulunur
↓
LLM bu kaynaklara dayanarak diagnosis üretir
↓
Kaynaklarıyla birlikte Flutter’a döner

1. Backend Supabase Storage’dan PDF’i indirir.

2. Backend PDF içindeki yazıyı çıkarır.

3. Backend yazıyı chunk’lara böler.

4. Her chunk PostgreSQL’e kaydedilir.
   Çünkü gerçek metni, sayfa bilgisini, doküman bilgisini tutmalıyız.

5. Her chunk için embedding oluşturulur.
   Yani metin sayı listesine çevrilir.

6. Embedding Qdrant’a kaydedilir.
   Çünkü semantic search orada yapılır.

7. Start AI Diagnosis basılınca:
   job context hazırlanır.
   Örnek query oluşturulur:
   "MX-200 E42 fan sensor error"

8. Bu query için embedding oluşturulur.

9. Qdrant’ta en yakın chunk’lar aranır.

10. Qdrant bize en alakalı chunk id’lerini döner.

11. Backend PostgreSQL’den bu chunk’ların gerçek metinlerini alır.

12. LLM’e şu verilir:
   - job bilgisi
   - ilgili kaynak chunk metinleri
   - output formatı

13. AI structured diagnosis döner.

PostgreSQL
→ job, document, document_chunks metinleri

Supabase Storage
→ PDF dosyaları

Qdrant
→ embedding/vector araması

Örneğin:

{
  "diagnosis": "E42 error detected. Likely a fan speed sensor issue.",
  "confidence": "medium",
  "recommendedSteps": [
    "Enter Safe Mode",
    "Check Fan Connector",
    "Measure Sensor Voltage"
  ],
  "sources": [
    {
      "title": "MX-200 Manual",
      "page": 14
    },
    {
      "title": "Sensor Guide",
      "section": "3.2"
    }
  ]
}

Bu artık klasik chatbot değil; kaynaklı AI diagnosis sistemi.

3. Analysis Complete ekranı

Bu ekran tam olarak ilerideki RAG + structured output ekranı.

Buradaki parçalar:

Diagnosis Summary
Recommended Steps
Verification Sources
Visual Reference
Create Service Note
Request Part

şu kavramlara bağlanacak:

RAG
tool calling
controlled actions
user confirmation
AI safety
source citation
structured output

Özellikle iki buton çok önemli:

Create Service Note
Request Part: Fan Sensor

Bunlar ileride tool calling ile yapılacak.

Ama kritik nokta şu:

AI kendi kafasına göre DB’ye yazmayacak.

Doğru akış:

AI önerir
↓
Backend tool action taslağı oluşturur
↓
Flutter kullanıcıya confirmation ekranı gösterir
↓
Kullanıcı onaylar
↓
Backend yetki kontrolü yapar
↓
DB’ye yazar / CRM’e sync eder

Yani:

AI → öneri
Kullanıcı → onay
Backend → güvenli aksiyon
4. Confirm Service Note ekranı

Bu ekran çok doğru düşünülmüş.

Buradaki:

AI VERIFIED ACTION
Safety Confirmation
Save and Sync

şu konulara bağlanacak:

human-in-the-loop
critical action confirmation
tool abuse prevention
insecure output handling önleme
audit log
CRM sync

AI servis notu oluşturabilir ama doğrudan kaydetmemeli.

Yanlış:

AI servis notunu üretti
↓
Otomatik DB’ye yazdı

Doğru:

AI servis notu taslağı üretir
↓
Teknisyen düzenler/onaylar
↓
Safety confirmation işaretlenir
↓
Backend kaydeder
↓
Audit log tutulur

Bu gerçek sektörde çok önemli. Çünkü AI hatalı not yazarsa operasyonel risk doğar.

5. Developer Debug Panel

Bu ekran müthiş değerli çünkü seni “sadece UI yaptım” seviyesinden çıkarır.

Buradaki:

Total Usage
Avg Latency
Input tokens
Output tokens
Cost
Tools
Timeout
Model
Live Trace

ileride şu konulara bağlanacak:

AI observability
token tracking
cost tracking
latency logging
tool call logs
agent trace
evals
fallback
timeout handling

Bu ekranı portföyde göstermek çok güçlü olur.

Mülakatta şöyle anlatırsın:

AI isteklerini sadece çalıştırmakla kalmadım; model, token usage, latency, cost, tool calls ve error durumlarını loglayan bir developer telemetry paneli tasarladım.

Bu junior biri için çok ayırt edici.

Öğreneceğimiz büyük AI kavramlarını projeye nasıl bağlayacağız?

Bu projede sırayla şunları ekleyeceğiz:

1. Backend üzerinden güvenli LLM API çağrısı
2. Structured output
3. Zod validation
4. AI priority analysis
5. AI diagnosis
6. RAG temeli
7. Embedding oluşturma
8. pgvector veya Qdrant ile vector search
9. Chunking + metadata
10. Source citation
11. Tool calling
12. Controlled agent workflow
13. Human confirmation
14. MCP mantığı
15. AI request logging
16. Token / latency / cost tracking
17. Evals
18. AI security

Supabase Storage
→ Sadece PDF / fotoğraf dosyalarını tutuyor.

PostgreSQL
→ Job, device, document metadata, service history ve AI tablolarını tutuyor.