# Course Data Manager (Course Explorer v3)

Praktikum Pemrograman Mobile — Pertemuan 7
**RESTful API, Backend Services & Database Integration**

- **Nama:** Syaeful Darmawan
- **NIM:** 2415051059
- **Program Studi:** Pendidikan Teknik Informatika
- **Universitas:** Universitas Pendidikan Ganesha

---

## Deskripsi Aplikasi
Aplikasi ini merupakan pengembangan dari Course Explorer (Pertemuan 5-6). Pada pertemuan ini, aplikasi terhubung ke backend database **Supabase** (PostgreSQL) untuk melakukan operasi CRUD (Create, Read, Update, Delete) secara *real-time*. Aplikasi mempertahankan fitur *responsive layout* (NavigationBar/NavigationRail), halaman detail, dan fitur *favorites*.

## Backend yang Digunakan
- **Database & API:** Supabase (PostgreSQL)
- **Package:** `supabase_flutter`
- **Tabel:** `courses` (id, code, title, credits, status, created_at)

## Cara Menjalankan Aplikasi
1. Clone repository ini.
2. Jalankan `flutter pub get`.
3. Buka file `lib/config/supabase_config.dart` dan masukkan `supabaseUrl` serta `supabaseAnonKey` milik Anda.
4. Jalankan `flutter run -d chrome`.

## Arsitektur
Aplikasi menggunakan pola **Repository Pattern**:
UI (Screens/Widgets) -> Provider -> Repository -> Data Source (Supabase).
Perakitan dependensi hanya dilakukan di `main.dart`.