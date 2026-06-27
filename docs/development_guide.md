# Panduan Arsitektur & Pengembangan TIU Adaptive

Dokumen ini menjelaskan arsitektur Model-View-ViewModel (MVVM) yang digunakan di aplikasi TIU Adaptive, serta urutan pembuatannya.

## 1. Arsitektur Aplikasi (MVVM)

Aplikasi ini menggunakan pola arsitektur **MVVM (Model-View-ViewModel)** dengan penambahan **Service Layer** dan **Service Locator** untuk memudahkan pemeliharaan dan menghindari *Spaghetti Code*. Berikut ini adalah peran dari setiap layer:

### A. Model (`lib/models/`)
Berisi class data murni (*pure data classes*) tanpa logika apapun.
- `tip_item.dart`: Merepresentasikan data tips dengan `num` dan `text`.
- `question.dart`: Merepresentasikan data soal pilihan ganda.

### B. Service / Data Layer (`lib/services/`)
Berfungsi untuk memuat data (dari API, file JSON, dll) dan menyimpan *business logic*.
- `tips_service.dart`: Memuat tips dari file JSON dan menampung *dictionary* (`tipsMap`, `categoryLabels`, dll) yang awalnya ada di logika global.
- `question_service.dart`: Berisi algoritma *procedural generation* untuk membuat soal matematika secara dinamis.
- `service_locator.dart`: Menyediakan *Dependency Injection* buatan sendiri (menggunakan pola *Singleton*) agar `QuestionService` dan `TipsService` dapat diakses dengan mudah tanpa harus *passing* instance antar widget. Semua inisialisasi awal (memuat data dari JSON) dipanggil melalui file ini.

### C. ViewModel (`lib/viewmodels/`)
Berperan sebagai penghubung antara UI dan Services, serta tempat state aplikasi berada.
- `procgen_viewmodel.dart`: Menyimpan state soal yang di-*generate*, jawaban user, skor, dll. ViewModel ini mewarisi `ChangeNotifier` dan memanggil `serviceLocator.questionService` untuk logic pembuatan soal.

### D. View / UI (`lib/screens/` & `lib/widgets/`)
Berisi komponen visual. Hanya bertugas untuk merender UI berdasarkan state di ViewModel dan meneruskan interaksi user (klik) ke metode di ViewModel.
- `procgen_panel.dart`: Mendengarkan perubahan di `ProcGenViewModel` menggunakan `ListenableBuilder` (tanpa package `provider` eksternal).
- `tips_box.dart`: UI yang membaca data tips melalui `serviceLocator.tipsService`.
- `splash_screen.dart`: Tempat utama dimana `serviceLocator.init()` dipanggil agar data (soal JSON & tips JSON) termuat dengan sempurna sebelum masuk ke `home_screen.dart`.

---

## 2. Urutan Pengembangan (Development Timeline)

Berikut ini adalah langkah-langkah historis dalam membangun dan merestrukturisasi (refactoring) arsitektur MVVM di aplikasi ini:

1. **Pembuatan UI Awal & Ekstraksi Data (Pra-MVVM)**
   - UI statis (seperti `splash_screen.dart` dan `tips_box.dart`) dibangun terlebih dahulu.
   - *Refactoring* awal dilakukan dengan memindahkan data mentah berformat Dart ke file `.json` (`assets/data/tips_data.json` & `assets/data/questions.json`).

2. **Perancangan Model Data (`lib/models/`)**
   - Class `TipItem` dan `Question` dibuat sebagai representasi struktur data agar lebih aman digunakan dan lebih mudah dikonversi dari JSON (menggunakan method `.fromJson`).

3. **Pembuatan Layer Service (`lib/services/`)**
   - Membuat file `question_service.dart` yang berisi logic generator soal algoritmik dari fungsi-fungsi global.
   - Membuat file `tips_service.dart` untuk memuat data dari file JSON asinkronus dan menyimpan nilai statis.
   - Membuat `service_locator.dart` sebagai pilar utama untuk instansiasi global.

4. **Integrasi ViewModel (`lib/viewmodels/`)**
   - `ProcGenViewModel` yang tadinya mengakses *global functions*, diubah agar menggunakan `serviceLocator`. Semua state lokal mengenai ujian ditempatkan di sini, sehingga View (UI) bersih dari logika kalkulasi nilai / algoritma pembuatan soal.

5. **Penyesuaian View / UI**
   - Di file `splash_screen.dart`, metode `serviceLocator.init()` ditambahkan pada saat *boot-up* aplikasi untuk memastikan semua JSON termuat asinkronus dengan aman.
   - Di `procgen_panel.dart` dan widget lainnya, referensi ke direktori `logic/` lawas diganti agar mengambil dari *service locator*.

6. **Cleanup**
   - Menghapus direktori dan file lama yang berserakan (`logic/generators.dart` dan `logic/tips_data.dart`) setelah fungsionalitasnya selesai dipindahkan ke Service Layer.
   - Memastikan tidak ada *error analyzer* menggunakan `flutter analyze`.

Dengan arsitektur ini, aplikasi sangat modular. Jika suatu hari ingin mengganti database dengan Firebase atau Supabase, Anda cukup memodifikasi *Service Layer* tanpa perlu menyentuh View atau ViewModel Anda!
