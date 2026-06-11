# Dokumentasi Unit Testing — Perpustakaan Digital

## Ringkasan Aplikasi

| Aspek | Keterangan |
|--------|------------|
| **Nama** | utspam_5b_0008_perpus (Perpustakaan Digital) |
| **Stack** | Flutter (Dart 3.9+), SQLite (sqflite), Provider |
| **Arsitektur** | 3-layer sederhana: Models → DatabaseHelper → Pages (UI) |
| **Fitur utama** | Registrasi/login, katalog 10 buku seed, peminjaman, riwayat, profil |

### Alur bisnis

1. **LoginPage** → autentikasi via email/NIK + password  
2. **RegisterPage** → validasi ketat (NIK 16 digit, email @gmail.com, dll.)  
3. **HomePage** → navigasi ke katalog, riwayat, profil  
4. **BookListPage** → grid buku + detail bottom sheet  
5. **BorrowFormPage** → hitung `totalCost = pricePerDay × durationDays`  
6. **BorrowingHistoryPage** / **BorrowingDetailPage** → kelola status (`aktif`, `selesai`, `dibatalkan`)

---

## 15 Unit Test Suite

| No | ID Suite | File | Skenario Utama | Jumlah Test ID |
|----|----------|------|----------------|----------------|
| 1 | UT-01 | `test/suites/ut01_user_model_test.dart` | Serialisasi model User | 3 |
| 2 | UT-02 | `test/suites/ut02_book_model_test.dart` | Serialisasi model Book | 3 |
| 3 | UT-03 | `test/suites/ut03_borrowing_model_test.dart` | Model Borrowing & status default | 4 |
| 4 | UT-04 | `test/suites/ut04_database_init_test.dart` | Inisialisasi DB & seed buku | 3 |
| 5 | UT-05 | `test/suites/ut05_user_create_test.dart` | Insert pengguna | 3 |
| 6 | UT-06 | `test/suites/ut06_user_query_test.dart` | Lookup email/NIK/username | 5 |
| 7 | UT-07 | `test/suites/ut07_book_catalog_test.dart` | Katalog buku | 4 |
| 8 | UT-08 | `test/suites/ut08_borrowing_create_test.dart` | Buat peminjaman | 3 |
| 9 | UT-09 | `test/suites/ut09_borrowing_query_test.dart` | Query riwayat peminjaman | 4 |
| 10 | UT-10 | `test/suites/ut10_borrowing_update_test.dart` | Update status & data pinjam | 3 |
| 11 | UT-11 | `test/suites/ut11_my_app_test.dart` | Widget MyApp | 3 |
| 12 | UT-12 | `test/suites/ut12_login_page_test.dart` | Login & validasi | 5 |
| 13 | UT-13 | `test/suites/ut13_register_page_test.dart` | Validasi registrasi | 6 |
| 14 | UT-14 | `test/suites/ut14_home_page_test.dart` | Dashboard & navigasi | 5 |
| 15 | UT-15 | `test/suites/ut15_profile_borrow_form_test.dart` | Profil & form pinjam | 5 |

**Total test case ID: 59**

---

## Command CLI

Jalankan dari folder proyek (`utspam_5b_0008_perpus-main`):

```bash
# Semua 15 suite
flutter test test/suites/

# Satu suite (contoh UT-12)
flutter test test/suites/ut12_login_page_test.dart

# Satu test ID berdasarkan nama
flutter test test/suites/ut12_login_page_test.dart --name "UT-12-004"

# Suite model saja (UT-01 s/d UT-03)
flutter test test/suites/ut01_user_model_test.dart test/suites/ut02_book_model_test.dart test/suites/ut03_borrowing_model_test.dart

# Suite database saja (UT-04 s/d UT-10)
flutter test test/suites/ut04_database_init_test.dart test/suites/ut05_user_create_test.dart test/suites/ut06_user_query_test.dart test/suites/ut07_book_catalog_test.dart test/suites/ut08_borrowing_create_test.dart test/suites/ut09_borrowing_query_test.dart test/suites/ut10_borrowing_update_test.dart

# Suite widget/UI (UT-11 s/d UT-15)
flutter test test/suites/ut11_my_app_test.dart test/suites/ut13_register_page_test.dart test/suites/ut14_home_page_test.dart test/suites/ut15_profile_borrow_form_test.dart

# Laporan coverage (opsional)
flutter test test/suites/ --coverage
```

### Prasyarat

```bash
flutter pub get
```

Unit test database memakai `sqflite_common_ffi` (sudah di `dev_dependencies`).

Setiap suite DB memakai file terisolasi (`test_utXX.db`) yang di-reset sebelum dijalankan. Widget test login memakai `tester.runAsync()` agar operasi SQLite selesai di luar fake async zone Flutter.
