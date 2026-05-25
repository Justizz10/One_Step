<div align="center">

<img src="assets/images/logo1.PNG" alt="One-Step Logo" width="120" height="120"/>

# ONE-STEP
### *One Way, One Closer*

**Aplikasi Mobile Kebugaran Berbasis Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Android](https://img.shields.io/badge/Android-6.0+-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

---

> 📱 Aplikasi mobile kebugaran yang membantu pengguna menjalani gaya hidup sehat melalui panduan olahraga harian, program diet berbasis WHO, pelacakan progres, dan sistem pengingat latihan.

</div>

---

## 📋 Daftar Isi

- [Deskripsi Aplikasi](#-deskripsi-aplikasi)
- [Fitur Utama](#-fitur-utama)
- [Teknologi yang Digunakan](#-teknologi-yang-digunakan)
- [Arsitektur Sistem](#️-arsitektur-sistem)
- [Struktur Database](#-struktur-database)
- [Screenshot](#-screenshot)
- [Cara Menjalankan](#-cara-menjalankan)
- [Instalasi APK](#-instalasi-apk)
- [Struktur Folder](#-struktur-folder)
- [Tim Pengembang](#-tim-pengembang)

---

## 📖 Deskripsi Aplikasi

**One-Step** adalah aplikasi mobile kebugaran (*fitness*) yang dikembangkan menggunakan framework **Flutter** dan berjalan pada platform **Android**. Aplikasi ini dirancang sebagai solusi digital bagi individu yang ingin menjalani gaya hidup sehat secara terstruktur dan konsisten.

### 🎯 Latar Belakang

Berdasarkan data Kementerian Kesehatan RI, prevalensi aktivitas fisik yang kurang memadai masih cukup tinggi di kalangan usia produktif. Kurangnya panduan olahraga yang terstruktur, minimnya motivasi, dan tidak adanya program latihan yang dipersonalisasi menjadi hambatan utama seseorang dalam menjaga konsistensi berolahraga.

**One-Step** hadir untuk menjawab tantangan tersebut dengan menyediakan platform kebugaran digital yang lengkap, mudah diakses, dan dapat dipersonalisasi sesuai kebutuhan pengguna.

### 🏆 Keunggulan

| Keunggulan | Deskripsi |
|-----------|-----------|
| 🇮🇩 **Bahasa Indonesia** | Antarmuka penuh Bahasa Indonesia, ramah pengguna lokal |
| 📊 **Berbasis WHO** | Menu diet & rekomendasi sesuai standar kesehatan WHO |
| 🔄 **Konten Dinamis** | Motivasi, rekomendasi olahraga & menu berganti otomatis tiap hari |
| 🔥 **Sistem Streak** | Pelacak konsistensi latihan mingguan yang memotivasi |
| 💪 **BMI Terintegrasi** | Kalkulasi BMI otomatis dari profil pengguna |
| 🔔 **Reminder Cerdas** | Notifikasi pengingat latihan tepat waktu |
| ☁️ **Cloud Sync** | Data tersimpan aman di Firebase, bisa diakses kapan saja |

---

## ✨ Fitur Utama

### 🔐 1. Autentikasi & Manajemen Akun
- Registrasi akun baru dengan email dan password
- Login aman menggunakan Firebase Authentication
- Pengelolaan sesi login otomatis (persistent login)
- Ubah kata sandi & hapus akun permanen

### 👤 2. Profil Pengguna (CRUD Lengkap)
- Edit profil lengkap: nama, username, jenis kelamin, usia
- Input data kebugaran: tinggi badan, berat badan, tujuan, tingkat aktivitas
- Upload foto profil dari galeri atau kamera
- Lihat foto profil full screen dengan fitur zoom
- Kalkulasi **BMI otomatis** sesuai standar WHO dengan kategori & saran

### 📅 3. Jadwal Latihan (CRUD Lengkap)
- Tambah jadwal latihan dengan pilihan aktivitas, tanggal, durasi & intensitas
- Tampilan daftar jadwal terurut dari waktu terdekat
- Tandai jadwal sebagai **selesai** (otomatis tercatat di progres)
- Hapus jadwal yang tidak dibutuhkan
- Preview **3 jadwal terdekat** di halaman beranda

### 🏃 4. Rekomendasi Olahraga Harian
- **7 variasi olahraga** berbeda setiap hari (Senin–Minggu)
- Informasi lengkap: nama, deskripsi, durasi, intensitas, estimasi kalori
- Tips latihan yang benar untuk menghindari cedera
- Tombol **"Tandai Selesai"** hanya bisa ditekan **1x per hari** (reset otomatis besok)
- Sesi langsung tercatat ke riwayat progres

### 🥗 5. Program Diet Berbasis WHO
- Kalkulasi target kalori harian menggunakan rumus **BMR (Mifflin-St Jeor)** + **TDEE**
- Distribusi makronutrien: Protein 30%, Karbohidrat 45%, Lemak 25%
- **7 variasi panduan menu** berbeda setiap hari (Senin–Minggu)
- Food log harian: catat & hapus makanan yang dikonsumsi
- Progress bar kalori visual dengan peringatan saat melebihi target
- Informasi nutrisi per makanan (kalori, protein, karbo, lemak)

### 📊 6. Pelacakan Progres & Streak
- Statistik mingguan: total sesi, total menit, total kalori terbakar
- Riwayat lengkap seluruh sesi latihan
- Progress bar visual menuju target 7 sesi per minggu
- **Sistem Streak Mingguan:**
  - Streak **naik (+1)** jika berhasil ≥ 7 sesi dalam seminggu
  - Streak **reset (0)** jika minggu berlalu dengan < 7 sesi
  - Ditampilkan di beranda dan halaman progres

### 🔔 7. Reminder & Notifikasi
- Jadwalkan notifikasi harian pada jam yang ditentukan
- Pesan motivasi dinamis berubah setiap hari
- Notifikasi tetap muncul meski HP dalam kondisi terkunci
- Test notifikasi langsung dari aplikasi
- Cek status reminder yang terjadwal

### 💬 8. Konten Motivasi Harian
- **31 kata motivasi** berbeda, otomatis berganti setiap tanggal
- Tampil di beranda, halaman reminder, dan kartu rekomendasi

---

## 🛠️ Teknologi yang Digunakan

### Framework & Bahasa Pemrograman

| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| ![Flutter](https://img.shields.io/badge/-Flutter-02569B?logo=flutter&logoColor=white) **Flutter** | 3.x | Framework pengembangan aplikasi mobile cross-platform |
| ![Dart](https://img.shields.io/badge/-Dart-0175C2?logo=dart&logoColor=white) **Dart** | 3.x | Bahasa pemrograman utama |

### Backend & Database (Firebase)

| Layanan | Fungsi |
|---------|--------|
| 🔐 **Firebase Authentication** | Autentikasi pengguna (email/password) |
| 🗄️ **Cloud Firestore** | Database NoSQL real-time untuk semua data pengguna |

### Package & Library Flutter

```yaml
dependencies:
  # Firebase
  firebase_core: ^3.3.0          # Inisialisasi Firebase
  firebase_auth: ^5.1.4          # Autentikasi pengguna
  cloud_firestore: ^5.2.1        # Database cloud

  # State Management
  provider: ^6.1.2               # Manajemen state MVVM

  # Fitur Utama
  flutter_local_notifications: ^17.2.2  # Notifikasi lokal
  timezone: ^0.9.4               # Timezone untuk reminder
  shared_preferences: ^2.3.2     # Penyimpanan preferensi lokal
  image_picker: ^1.1.2           # Upload foto profil
  permission_handler: ^11.3.1    # Manajemen izin runtime
  fl_chart: ^0.68.0              # Grafik & visualisasi data
```

### Tools Pengembangan

| Tools | Fungsi |
|-------|--------|
| 🛠️ **Android Studio** | IDE utama pengembangan Flutter |
| 🔥 **Firebase Console** | Manajemen backend & database |
| 🎨 **Figma** | Desain UI/UX & wireframe |
| 📊 **Draw.io** | Pembuatan diagram UML |

---

## 🏗️ Arsitektur Sistem

Aplikasi One-Step menggunakan pola arsitektur **MVVM (Model-View-ViewModel)**:

```
lib/
├── models/              ← Struktur data (Model)
│   ├── user_model.dart
│   ├── schedule_model.dart
│   └── diet_model.dart
│
├── views/               ← Tampilan antarmuka (View)
│   ├── screens/
│   │   ├── main_screen.dart        # Bottom Navigation
│   │   ├── beranda_screen.dart     # Dashboard
│   │   ├── jadwal_screen.dart      # Jadwal Latihan
│   │   ├── diet_screen.dart        # Program Diet
│   │   ├── progres_screen.dart     # Progres & Streak
│   │   ├── profil_screen.dart      # Profil Pengguna
│   │   ├── edit_profil_screen.dart # Edit Profil
│   │   ├── login_screen.dart       # Halaman Login
│   │   ├── register_screen.dart    # Halaman Registrasi
│   │   ├── reminder_screen.dart    # Pengaturan Reminder
│   │   └── foto_profil_screen.dart # Lihat Foto Full Screen
│   └── widgets/
│       └── bmi_card_widget.dart    # Widget BMI Reusable
│
├── services/            ← Logika bisnis & API (ViewModel)
│   ├── auth_service.dart           # Firebase Auth
│   ├── profile_service.dart        # CRUD Profil
│   ├── schedule_service.dart       # CRUD Jadwal
│   ├── diet_service.dart           # Kalori & Food Log
│   ├── progress_service.dart       # Progres & Streak
│   └── notification_service.dart   # Notifikasi Lokal
│
└── utils/               ← Helper & Konstanta
    ├── app_colors.dart             # Palet warna
    ├── app_text_styles.dart        # Style teks
    ├── bmi_helper.dart             # Kalkulasi BMI WHO
    ├── motivasi_helper.dart        # 31 kata motivasi
    ├── rekomendasi_helper.dart     # 7 rekomendasi olahraga
    ├── menu_helper.dart            # 7 menu diet WHO
    └── image_helper.dart           # Helper foto Base64
```

---

## 🗄️ Struktur Database

Aplikasi menggunakan **Firebase Cloud Firestore** dengan 5 koleksi:

```
Firestore Database
│
├── users/{uid}
│   ├── name, username, email
│   ├── gender, age, height, weight
│   ├── goal, activityLevel
│   ├── photoUrl (Base64)
│   ├── streak, nomorMingguTerakhir
│   └── createdAt, updatedAt
│
├── schedules/{scheduleId}
│   ├── userId (FK → users)
│   ├── activityName, duration
│   ├── scheduledDate, intensity
│   └── status (planned/completed/skipped)
│
├── progress/{progressId}
│   ├── userId (FK → users)
│   ├── activityName, duration
│   ├── caloriesBurned
│   └── completedAt
│
├── foodLogs/{logId}
│   ├── userId (FK → users)
│   ├── logDate, mealType
│   ├── foodName, portion
│   └── calories, protein, carbs, fat
│
└── weightHistory/{recordId}
    ├── userId (FK → users)
    ├── weight
    └── recordedAt
```

---

## 📱 Screenshot


| Splash Screen | Login | Beranda |
|:---:|:---:|:---:|
| `[Screenshot]` | `[Screenshot]` | `[Screenshot]` |

| Jadwal | Diet | Progres |
|:---:|:---:|:---:|
| `[Screenshot]` | `[Screenshot]` | `[Screenshot]` |

| Profil | Edit Profil | Reminder |
|:---:|:---:|:---:|
| `[Screenshot]` | `[Screenshot]` | `[Screenshot]` |

> **Cara menambahkan screenshot:**
> 1. Buat folder `screenshots/` di root project
> 2. Simpan gambar dengan nama: `splash.png`, `login.png`, dst.
> 3. Ganti teks `[Screenshot]` di atas dengan:
>    ```markdown
>    ![Nama](screenshots/nama_file.png)
>    ```

---

## 🚀 Cara Menjalankan

### Prasyarat

Pastikan sistem Anda sudah terpasang:

- ✅ [Flutter SDK](https://flutter.dev/docs/get-started/install) versi 3.x ke atas
- ✅ [Android Studio](https://developer.android.com/studio) dengan plugin Flutter & Dart
- ✅ [Git](https://git-scm.com/)
- ✅ Android Emulator (API 23+) atau perangkat Android fisik
- ✅ Akun [Firebase](https://firebase.google.com/) (untuk konfigurasi backend)

### Langkah 1 — Clone Repository

```bash
git clone https://github.com/username/one_step.git
cd one_step
```

### Langkah 2 — Install Dependencies

```bash
flutter pub get
```

### Langkah 3 — Konfigurasi Firebase

1. Buat project baru di [Firebase Console](https://console.firebase.google.com)
2. Daftarkan aplikasi Android dengan package name: `com.example.one_step`
3. Download file `google-services.json`
4. Letakkan di: `android/app/google-services.json`
5. Aktifkan layanan berikut di Firebase Console:
   - **Authentication** → Email/Password
   - **Cloud Firestore** → Start in test mode
6. Buat Firestore Indexes berikut:

```
Collection: schedules   → userId (ASC) + scheduledDate (ASC)
Collection: foodLogs    → userId (ASC) + logDate (ASC)
Collection: progress    → userId (ASC) + completedAt (DESC)
```

### Langkah 4 — Jalankan Aplikasi

```bash
# Mode debug (development)
flutter run

# Mode release (production)
flutter run --release
```

### Langkah 5 — Build APK

```bash
# Build APK universal
flutter build apk --release

# Build APK per arsitektur (ukuran lebih kecil)
flutter build apk --release --split-per-abi
```

File APK tersedia di:
```
build/app/outputs/flutter-apk/
├── app-armeabi-v7a-release.apk   # HP 32-bit (lama)
├── app-arm64-v8a-release.apk     # HP 64-bit (modern) ✅
└── app-x86_64-release.apk        # Emulator
```

---

## 📲 Instalasi APK

### Via Kabel USB (ADB)
```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### Via Transfer File
1. Salin file `.apk` ke HP
2. Buka **File Manager** di HP
3. Tap file `.apk` → **Install**
4. Jika muncul peringatan → **Settings** → aktifkan **Install from Unknown Sources**

### Pengaturan Wajib Setelah Install
Agar notifikasi reminder berfungsi optimal:
```
Settings → Apps → One-Step → Battery → Unrestricted
Settings → Apps → One-Step → Permissions → Alarms & Reminders → Allow
```
Untuk HP Xiaomi/MIUI:
```
Settings → Apps → Manage Apps → One-Step → Autostart → ON
```

---

## 📁 Struktur Folder Lengkap

```
one_step/
├── android/                    # Konfigurasi Android native
│   └── app/
│       ├── build.gradle.kts    # Gradle config
│       ├── google-services.json # Firebase config
│       └── src/main/
│           └── AndroidManifest.xml
│
├── assets/                     # Aset statis
│   └── images/
│       └── logo1.PNG           # Logo One-Step
│
├── lib/                        # Source code utama ← FOCUS HERE
│   ├── main.dart               # Entry point + Splash Screen
│   ├── models/                 # Data models
│   ├── views/                  # UI screens & widgets
│   ├── services/               # Business logic & Firebase
│   └── utils/                  # Helpers & constants
│
├── test/                       # Unit & widget tests
├── pubspec.yaml                # Dependencies & assets config
└── README.md                   # Dokumentasi ini
```

---

## 🧪 Pengujian

Aplikasi diuji menggunakan metode **Black Box Testing** dengan total **50 skenario uji** yang mencakup:

| Modul | Jumlah Skenario | Status |
|-------|----------------|--------|
| Autentikasi & Akun | 9 | ✅ Pass |
| Profil Pengguna | 10 | ✅ Pass |
| Jadwal Latihan | 8 | ✅ Pass |
| Program Diet | 8 | ✅ Pass |
| Progres & Streak | 8 | ✅ Pass |
| Reminder & Notifikasi | 8 | ✅ Pass |
| Non-Fungsional | 9 | ✅ Pass |

Menjalankan unit test:
```bash
flutter test
```

---

## 📊 Analisis Sistem

| Dokumen | Keterangan |
|---------|-----------|
| 📄 Proposal Sistem | Tersedia di folder `docs/` |
| 📋 SRS (Software Requirements Specification) | Tersedia di folder `docs/` |
| 🗺️ ERD (Entity Relationship Diagram) | `docs/ERD_OneStep.puml` |
| 🔄 Flow Diagram | `docs/FlowDiagram_OneStep.puml` |

---

## ⚠️ Catatan Penting

```yaml
Platform    : Android saja (iOS belum didukung)
Min Android : 6.0 Marshmallow (API Level 23)
Min RAM     : 2 GB
Storage     : Minimal 100 MB tersedia
Internet    : Diperlukan untuk login, sync data, dan Firebase
```

> **Disclaimer:** Data rekomendasi diet dan BMI bersifat informatif umum dan **bukan merupakan saran medis profesional**. Selalu konsultasikan dengan dokter atau ahli gizi untuk program diet yang dipersonalisasi.

---

## 👨‍💻 Tim Pengembang

<div align="center">

| Nama | NIM | Role |
|------|-----|------|
| **[Nama Mahasiswa]** | [XXXXXXXXXX] | Flutter Developer |

**Program Studi:** Sistem Informasi  
**Institusi:** [Nama Universitas]  
**Tahun:** 2025

</div>

---

## 📄 Lisensi

```
MIT License

Copyright (c) 2025 One-Step Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

<div align="center">

**⭐ Jika project ini membantu, berikan bintang di GitHub!**

Made with ❤️ using Flutter & Firebase

*One Way, One Closer — One-Step* 🏃

</div>
