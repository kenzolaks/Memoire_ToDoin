# Memoire_ToDoApp

## a. Developers
Laksamana Aditya P (Back-End Programmer)

Atiqa Raisa Mumtaz (UI/UX Designer)

## 📌 Aplikasi Manajemen Tugas Pribadi

### 📱 Deskripsi Fungsionalitas Aplikasi
Aplikasi **Memoire** adalah aplikasi manajemen tugas harian yang dikembangkan menggunakan Flutter dan Firebase. Aplikasi ini dirancang untuk membantu pengguna mengatur aktivitas sehari-hari secara efisien melalui tampilan modern dan interaktif, dilengkapi dengan fitur:

- Registrasi dan login menggunakan email & password (Firebase Authentication)
- Menambahkan tugas dengan judul, deskripsi, dan tanggal
- Menampilkan tugas berdasarkan tanggal dalam tampilan kalender interaktif
- Mengedit dan menghapus tugas
- Menandai tugas sebagai selesai
- Dukungan tema gelap dan terang secara manual

---

### 🛠 Teknologi yang Digunakan
- **Flutter** – UI Framework
- **Dart** – Bahasa pemrograman utama
- **Firebase Authentication** – Login dan registrasi akun
- **Firebase Firestore** – Penyimpanan data cloud real-time
- **Provider** – Manajemen state untuk tema dan data
- **TableCalendar** – Plugin Flutter untuk tampilan kalender
- **Git & GitHub** – Version control dan hosting proyek

---

### ▶️ Cara Menjalankan Aplikasi

#### 1. Clone Repository
```bash
git clone https://github.com/username/to_do_in.git
cd to_do_in
```

#### 2. Buka Proyek di Visual Studio Code
Pastikan sudah terinstal Flutter SDK.

#### 3. Install Dependencies
```bash
flutter pub get
```

#### 4. Integrasi Firebase
- Buka [Firebase Console](https://console.firebase.google.com/)
- Buat proyek baru
- Tambahkan aplikasi Android
  - Ambil `package name` dari: `android/app/src/main/AndroidManifest.xml`
- Unduh `google-services.json` dan tempatkan di:  
  `android/app/google-services.json`
- Aktifkan Authentication:
  - Masuk ke **Authentication > Sign-in method > Email/Password**
- Buat database di **Firestore Database** dan buat koleksi tugas

#### 5. Konfigurasi Firebase di Flutter
Jalankan perintah berikut:
```bash
flutterfire configure
```

Inisialisasi Firebase di `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

#### 6. Jalankan Aplikasi
Pastikan emulator aktif atau perangkat fisik tersambung, lalu:
```bash
flutter run
```

---

### 🖼️ Tampilan UI (Screenshots)
>
