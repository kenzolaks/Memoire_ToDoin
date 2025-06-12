# Memoire_ToDoIn

## Developers
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
![13](https://github.com/user-attachments/assets/495ce33d-ce8c-4c9e-a0d3-1d1b1eaeae2e)

![1](https://github.com/user-attachments/assets/d2ef0c11-9d57-43dc-8f39-d6e94abbbdac)

![4](https://github.com/user-attachments/assets/ce0f624a-107d-45e4-91fd-21560960d6f5)

![2 ](https://github.com/user-attachments/assets/7496fd57-5549-4103-b533-00d2d556ab29)

![3](https://github.com/user-attachments/assets/1f169d2b-7fda-40b3-b7f5-6f76627f5cfc)

![6](https://github.com/user-attachments/assets/17acda72-06f4-4544-b52c-9c56d1fb609e)

![5](https://github.com/user-attachments/assets/5681af20-59eb-4d1c-9f80-c81c1baaa288)

![7](https://github.com/user-attachments/assets/224f2cde-4d76-468f-a366-10464cc8ac38)

![8](https://github.com/user-attachments/assets/fb5f23b0-fadc-43f6-a71a-e757ee9bfc80)

![10](https://github.com/user-attachments/assets/8f7d4132-0fb8-4f42-b7e1-a596cc9b82b2)

![9](https://github.com/user-attachments/assets/2664dd3e-c17a-4e29-8bb6-8215ad3b129d)

![11](https://github.com/user-attachments/assets/2cc6d9be-92cb-4e99-8227-b2d7a5780b54)

![12](https://github.com/user-attachments/assets/17ae4b82-32fb-4c6c-ac0b-1c5083258733)

