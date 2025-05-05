# 🏡 SiDukun - Sistem Informasi Data Kependudukan Desa

**SiDukun** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan pendataan dan pengelolaan informasi kependudukan di tingkat desa. Aplikasi ini terhubung langsung ke Firebase untuk memastikan data tersimpan secara real-time, aman, dan dapat diakses kapan saja.

---

## 📱 Fitur Unggulan

- 📋 **Manajemen Data Warga**  
  Tambah, edit, dan hapus data penduduk seperti nama, NIK, alamat, jenis kelamin,agama, pekerjaan, dan status perkawinan.

- 🔍 **Pencarian Cepat**  
  Temukan data warga berdasarkan NIK atau nama dengan mudah dan cepat.

- 📊 **Statistik Kependudukan**  
  Visualisasi data berdasarkan usia, jenis kelamin, pekerjaan, dan lainnya.

- 🔐 **Autentikasi Pengguna**  
  Sistem login menggunakan Firebase Authentication untuk membatasi akses pengguna.

- ☁️ **Penyimpanan Cloud**  
  Menggunakan Firebase Firestore untuk menyimpan data secara real-time dan terpusat.

---

## 🛠️ Teknologi yang Digunakan

- **Flutter** – Framework UI lintas platform
- **Firebase Firestore** – Database real-time berbasis cloud
- **Firebase Authentication** – Sistem autentikasi pengguna

---

## 🚀 Cara Menjalankan Aplikasi

1. **Clone Repositori**
   ```bash
   git clone https://github.com/namamu/sidukun.git
   cd sidukun

2. **Install Dependencies**
   ```bash
   flutter pub get
   
3. **Integrasikan Firebase**
   - Buat Project di Firebase Consol
   - Tambahkan konfigurasi google-services.json (Android) atau GoogleService-Info.plist (iOS) ke dalam project Flutter

4. **Running Aplikasi**
   ```bash
   flutter run
