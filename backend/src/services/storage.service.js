/* Örneğin şunu verirsek:
bucketName: 'fieldai-documents'
objectKey: 'manuals/mx-200-manual.pdf'

Backend Supabase’e şunu sorar:  fieldai-documents bucket içindeki manuals/mx-200-manual.pdf
dosyası için bana geçici bir erişim linki üret. Sonuç olarak Flutter’ın açabileceği geçici bir URL döner.
*/
import { supabaseAdmin } from '../config/supabase.js';

export async function createStorageSignedUrl({
  bucketName,
  objectKey,
  expiresInSeconds = 3600
}) {
  if (!bucketName) {
    throw new Error('bucketName is required');
  }

  if (!objectKey) {
    throw new Error('objectKey is required');
  }

  const { data, error } = await supabaseAdmin
    .storage
    .from(bucketName)
    .createSignedUrl(objectKey, expiresInSeconds);

  if (error) {
    throw new Error(
      `Signed URL could not be created for ${bucketName}/${objectKey}: ${error.message}`
    );
  }

  return data.signedUrl;
}