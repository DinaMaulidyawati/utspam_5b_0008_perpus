import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utspam_5b_0008_perpus/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Book Browsing Integration Test', () {
    testWidgets('Melihat Daftar dan Detail Buku', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // --- 1. Persiapan: Login atau Register Cepat ---
      // Kita coba login dulu dengan akun test sebelumnya
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email atau NIK'),
          'testuser123@gmail.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.pumpAndSettle();
      
      final masukBtn = find.widgetWithText(FilledButton, 'Masuk');
      await tester.ensureVisible(masukBtn);
      await tester.tap(masukBtn);
      await tester.pumpAndSettle();

      // Jika gagal login (karena DB kerest), kita coba buat akun baru dari awal.
      if (find.text('Eksplorasi').evaluate().isEmpty) {
        final daftarSekarangBtn = find.text('Daftar Sekarang');
        await tester.tap(daftarSekarangBtn);
        await tester.pumpAndSettle();

        await tester.enterText(find.widgetWithText(TextFormField, 'Nama Lengkap'), 'Browser');
        await tester.enterText(find.widgetWithText(TextFormField, 'NIK'), '1111222233334444');
        await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'browser@gmail.com');
        await tester.enterText(find.widgetWithText(TextFormField, 'Alamat'), 'Jl. Browse');
        await tester.enterText(find.widgetWithText(TextFormField, 'Nomor Telepon'), '08999999999');
        await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'browser1');
        await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final daftarBtn = find.widgetWithText(FilledButton, 'Daftar');
        await tester.ensureVisible(daftarBtn);
        await tester.tap(daftarBtn);
        await tester.pumpAndSettle();

        await tester.enterText(find.widgetWithText(TextFormField, 'Email atau NIK'), 'browser@gmail.com');
        await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
        await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
        await tester.pumpAndSettle();
      }

      // --- 2. Skenario Utama: Browsing Buku ---
      // Pastikan kita ada di Home Page
      expect(find.text('Eksplorasi'), findsOneWidget);

      // Tap menu "Jelajahi Koleksi Buku"
      final jelajahiMenu = find.text('Jelajahi Koleksi Buku');
      await tester.ensureVisible(jelajahiMenu);
      await tester.tap(jelajahiMenu);
      await tester.pumpAndSettle();

      // Pastikan masuk ke halaman "Daftar Buku"
      expect(find.text('Daftar Buku'), findsOneWidget);

      // Cari buku "Clean Code" (Buku dummy default pertama)
      final cleanCodeBook = find.text('Clean Code');
      expect(cleanCodeBook, findsOneWidget);

      // Tap bukunya untuk melihat detail
      await tester.tap(cleanCodeBook);
      await tester.pumpAndSettle();

      // Pastikan pop-up/bottom sheet detail muncul yang berisi Sinopsis
      expect(find.text('Sinopsis'), findsOneWidget);
      expect(find.text('Pinjam Buku Ini'), findsOneWidget);
    });
  });
}
