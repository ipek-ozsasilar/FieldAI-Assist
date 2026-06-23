//pg paketinden PostgreSQL bağlantı havuzu alıyoruz. Pool şu demek: Backend PostgreSQL’e her sorguda
//sıfırdan bağlantı açmasın bağlantıları daha düzenli yönetsin.
//pg paketi PostgreSQL bağlantısı kurmamızı sağlar.
const { Pool } = require("pg"); 
const dotenv = require("dotenv");

dotenv.config();

const pool = new Pool({
    //DB bağlantı bilgisini .env dosyasından okuyoruz.
  connectionString: process.env.DATABASE_URL,
});

//Bu satırda oluşturduğumuz pool nesnesini başka dosyaların kullanımına açıyoruz.
//Başka dosyalar bu pool nesnesini kullanarak, sorgu atarak PostgreSQL’e bağlanabilir.
module.exports = pool;