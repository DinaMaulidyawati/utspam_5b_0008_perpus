import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utspam_5b_0008_perpus/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Kita gunakan waktu sebagai username & email unik agar tidak bentrok
  // jika tes dijalankan berulang-ulang tanpa hapus data emulator.
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final email = 'user$timestamp@gmail.com';
  final username = 'user$timestamp';
  final password = 'password123';

  // Helper function untuk mempermudah login di setiap test
  Future<void> loginHelper(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final isAlreadyLoggedIn = find.text('Eksplorasi').evaluate().isNotEmpty;
    if (isAlreadyLoggedIn) return;

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email atau NIK'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), password);
    await tester.pumpAndSettle();
    
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final masukBtn = find.widgetWithText(FilledButton, 'Masuk');
    await tester.ensureVisible(masukBtn);
    await tester.tap(masukBtn);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  group('Full App Integration Test', () {
    
    testWidgets('1. Alur Registrasi dan Login', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap Daftar
      await tester.tap(find.text('Daftar Sekarang'));
      await tester.pumpAndSettle();

      // Isi Form
      await tester.enterText(find.widgetWithText(TextFormField, 'Nama Lengkap'), 'Test User');
      await tester.enterText(find.widgetWithText(TextFormField, 'NIK'), '1234567812345678');
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), email);
      await tester.enterText(find.widgetWithText(TextFormField, 'Alamat'), 'Jl. Test');
      await tester.enterText(find.widgetWithText(TextFormField, 'Nomor Telepon'), '081234567890');
      await tester.enterText(find.widgetWithText(TextFormField, 'Username'), username);
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), password);
      
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final daftarBtn = find.widgetWithText(FilledButton, 'Daftar');
      await tester.ensureVisible(daftarBtn);
      await tester.tap(daftarBtn);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Login
      await tester.enterText(find.widgetWithText(TextFormField, 'Email atau NIK'), email);
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), password);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final masukBtn = find.widgetWithText(FilledButton, 'Masuk');
      await tester.ensureVisible(masukBtn);
      await tester.tap(masukBtn);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Eksplorasi'), findsOneWidget);
    });

    testWidgets('2. Melihat Daftar dan Detail Buku', (tester) async {
      await loginHelper(tester);

      await tester.tap(find.text('Jelajahi Koleksi Buku'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Daftar Buku'), findsOneWidget);
      expect(find.text('Clean Code'), findsOneWidget);

      await tester.tap(find.text('Clean Code'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Sinopsis'), findsOneWidget);
      expect(find.text('Pinjam Buku Ini'), findsOneWidget);
    });

    testWidgets('3. Alur Peminjaman Buku', (tester) async {
      await loginHelper(tester);

      // Ke Daftar Buku
      await tester.tap(find.text('Jelajahi Koleksi Buku'));
      await tester.pumpAndSettle();

      // Buka Clean Code
      await tester.tap(find.text('Clean Code'));
      await tester.pumpAndSettle();

      // Tekan Pinjam Buku Ini
      await tester.tap(find.text('Pinjam Buku Ini'));
      await tester.pumpAndSettle();

      // Isi Durasi
      await tester.enterText(find.widgetWithText(TextFormField, 'Lama Pinjam (hari)'), '5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Konfirmasi Peminjaman
      final konfirmasiBtn = find.widgetWithText(FilledButton, 'Konfirmasi Peminjaman');
      await tester.ensureVisible(konfirmasiBtn);
      await tester.tap(konfirmasiBtn);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Harusnya dilempar ke halaman Riwayat
      expect(find.text('Riwayat Peminjaman'), findsOneWidget);
      expect(find.text('Clean Code'), findsWidgets);
    });

    testWidgets('4. Melihat Riwayat Peminjaman', (tester) async {
      await loginHelper(tester);

      // Tap menu Riwayat di HomePage
      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Riwayat Peminjaman'), findsOneWidget);
      // Harus ada buku yang kita pinjam di langkah 3
      expect(find.text('Clean Code'), findsWidgets);
    });

    testWidgets('5. Update Status Peminjaman / Pembatalan', (tester) async {
      await loginHelper(tester);

      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();

      // Buka detail riwayat yang ada
      await tester.tap(find.text('Clean Code').first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Informasi Peminjaman'), findsOneWidget);

      // Batalkan Peminjaman
      final batalBtn = find.text('Batalkan Peminjaman');
      if (batalBtn.evaluate().isNotEmpty) {
        await tester.ensureVisible(batalBtn);
        await tester.tap(batalBtn);
        await tester.pumpAndSettle();

        // Dialog Konfirmasi
        await tester.tap(find.text('Ya, Batalkan'));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }
    });

    testWidgets('6. Melihat Data Profil', (tester) async {
      await loginHelper(tester);

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Profil Pengguna'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text(email), findsOneWidget);
    });
  });
}
