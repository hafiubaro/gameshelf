# GameShelf - UTS Mobile Programming

Aplikasi katalog game Flutter dengan tema gelap, ilustrasi ikon lokal, pencarian,
kategori, detail, dan favorit. Semua 8 game, rating, dan pengembang adalah data
fiktif untuk demonstrasi. Aplikasi tidak membutuhkan API maupun jaringan saat
berjalan. Desain dibuat mandiri khusus untuk tugas ini.

## Status paket

Kode aplikasi lengkap, JSON, rancangan UI, laporan, serta 13 kasus pengujian
tersedia. Flutter SDK tidak tersedia di lingkungan penyusunan: `flutter analyze`,
`flutter test`, dan aplikasi belum dijalankan. Jangan menganggap rancangan UI
sebagai screenshot aplikasi atau hasil uji yang sudah lulus.

Folder native Android dan web perlu dibuat menggunakan Flutter SDK lokal,
sesuai langkah berikut. Tidak ada APK atau klaim build berhasil dalam paket ini.

## Menjalankan

Prasyarat: Flutter yang menyertakan Dart >=3.3.0 dan <4.0.0; Android SDK/emulator
untuk Android atau Chrome untuk web. Gunakan instalasi Flutter yang sudah dipakai
untuk tugas sebelumnya. Tidak ada paket pihak ketiga dan tidak perlu build_runner.

Ekstrak ZIP, masuk ke folder `gameshelf`, lalu jalankan:

```bash
flutter --version
flutter doctor
flutter create --empty --project-name gameshelf --platforms=android,web .
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run
```

Untuk web: `flutter run -d chrome`. Untuk APK setelah pengujian:
`flutter build apk --release`. File berada di
`build/app/outputs/flutter-apk/app-release.apk`.

Perintah `flutter create` melengkapi scaffold platform. Pastikan `lib/main.dart`
tetap berisi `GameShelfApp` dan pubspec tetap mendaftarkan `assets/data/games.json`.
Jangan menyalin tanda backslash, HTML entity, atau format miring ke YAML.

## Halaman dan navigasi

| Halaman | Fungsi | Jalan masuk |
|---|---|---|
| HomePage | Hero, pencarian judul/genre/platform, kategori, katalog | Awal aplikasi |
| CategoryPage | Daftar dan pencarian khusus satu genre | Chip kategori di beranda |
| DetailPage | Informasi game, rating dummy, fitur, tombol favorit | Kartu game |
| FavoritesPage | Game yang disimpan pada sesi ini | Ikon hati pada AppBar beranda |

Navigasi memakai `Navigator.push` dan `MaterialPageRoute`; tombol kembali memakai
stack Navigator. Objek `Game` diteruskan ke detail. Satu `FavoritesStore` yang
sama diteruskan ke semua halaman; `ListenableBuilder` memperbarui UI favorit.
Favorit hilang ketika aplikasi ditutup/dimulai ulang, karena belum persisten.

## Struktur

```text
lib/
  main.dart
  models/game.dart
  data/game_repository.dart
  data/favorites_store.dart
  pages/home_page.dart
  pages/category_page.dart
  pages/detail_page.dart
  pages/favorites_page.dart
  widgets/game_widgets.dart
assets/data/games.json
test/gameshelf_test.dart
docs/
  rancangan_ui.png
  Laporan_UTS_GameShelf.pdf
  laporan_editable.md
  checklist_pengujian.csv
```

## Widget dan responsivitas

Scaffold, AppBar, SafeArea, SingleChildScrollView, Column, Row, Expanded,
Container, Stack, Card, InkWell, Wrap, Chip, TextField, FilledButton,
FutureBuilder, ListenableBuilder, dan LayoutBuilder digunakan sesuai fungsinya.
Lebar konten dibatasi 1160 px. Berdasarkan lebar ruang katalog setelah padding:
<600 px = satu kolom, 600-949 px = dua, >=950 px = tiga. Tinggi kartu tidak
terkunci agar judul atau teks besar bisa membungkus. Halaman dapat digulir.

## Data dan pengembangan API

Setiap objek mempunyai `id`, `title`, `genre`, `platform`, `developer`, `rating`,
`description`, `color`, `symbol`, `features`. ID harus unik; rating 0-5.
`Game.fromJson` memetakan data ke model; `toJson` melakukan kebalikannya.
`color` adalah string ARGB heksadesimal delapan digit. `symbol` dipetakan ke ikon
Material dan memiliki fallback. Seluruh ilustrasi dirender widget, bukan URL gambar.

`GameRepository.fetchGames()` menjadi kontrak asinkron. Untuk tahap API, buat
`ApiGameRepository implements GameRepository`, lakukan HTTP dan pemetaan respons
ke `Game`, lalu injeksikan repository itu ke `GameShelfApp`. Sesuaikan adapter
jika nama field server berbeda; tambah timeout dan penanganan respons non-200.
Endpoint server belum diberikan pada soal sehingga implementasi API bukan
bagian versi ini. Tambahkan penyimpanan lokal jika favorit perlu bertahan.

## Pengujian

13 kasus dalam `test/gameshelf_test.dart` memeriksa round-trip JSON, rentang
rating, pencarian, perubahan favorit, ID duplikat, asset nyata, navigasi,
sinkronisasi favorit, retry, empty state, serta 3 ukuran layar.
**Status: belum dieksekusi.** Isi `docs/checklist_pengujian.csv` setelah melakukan
pengujian sebenarnya. Periksa juga landscape dan font sistem 150-200% pada perangkat.

## Melengkapi laporan dan pengumpulan

1. Isi nama, NIM, kelas, fakultas/universitas pada `docs/laporan_editable.md`.
2. Masukkan logo fakultas resmi, bukan logo rekaan.
3. Jalankan aplikasi; ambil screenshot beranda, kategori, detail, dan favorit.
4. Ganti bagian bukti implementasi dengan screenshot asli dan isi hasil uji.
5. Salin naskah editable ke Word/Google Docs, tata ulang, lalu ekspor PDF akhir.
6. Buat repositori GitHub melalui akun sendiri. Upload proyek beserta README,
   JSON, test, dan scaffold platform yang sudah dibuat. Jangan upload build/.
7. Upload PDF akhir ke Google Drive; atur akses pembaca sesuai ketentuan dosen.
8. Periksa kedua tautan dari jendela privat sebelum dikumpulkan.

Tautan GitHub dan Drive belum dibuat karena akun/tujuan publikasi belum diberikan.

## Referensi teknis

- Soal UTS(1).pdf, Mobile Programming, Ganjil 2025/2026.
- https://docs.flutter.dev/cookbook/navigation/passing-data
- https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html
- https://docs.flutter.dev/ui/adaptive-responsive/general

Rancangan di `docs/rancangan_ui.png` merupakan desain awal mandiri, bukan
screenshot emulator dan bukan salinan contoh GUI pada soal.
