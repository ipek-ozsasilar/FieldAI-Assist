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