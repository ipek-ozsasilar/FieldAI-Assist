// Bu dosya Supabase bağlantısını kuracak.
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

dotenv.config();

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseSecretKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl) {
  throw new Error('SUPABASE_URL is missing in .env');
}

if (!supabaseSecretKey) {
  throw new Error('SUPABASE_SERVICE_ROLE_KEY is missing in .env');
}

//Supabase bağlantısı oluşturur.
//supabaseAdmin backend tarafında Storage ile konuşacak client.
export const supabaseAdmin = createClient(
  supabaseUrl,
  supabaseSecretKey,
  {
    auth: {
      persistSession: false,
      autoRefreshToken: false
    }
  }
);