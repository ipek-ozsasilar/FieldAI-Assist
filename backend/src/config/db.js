//pg paketinden PostgreSQL bağlantı havuzu alıyoruz. Pool şu demek: Backend PostgreSQL’e her sorguda
//sıfırdan bağlantı açmasın bağlantıları daha düzenli yönetsin.
const { Pool } = require("pg"); 
const dotenv = require("dotenv");

dotenv.config();

const pool = new Pool({
    //DB bağlantı bilgisini .env dosyasından okuyoruz.
  connectionString: process.env.DATABASE_URL,
});

module.exports = pool;