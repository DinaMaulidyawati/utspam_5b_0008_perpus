import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:utspam_5b_0008_perpus/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Integration Test', () {
    testWidgets('Alur Registrasi dan Login', (tester) async {
      // Jalankan aplikasi
      app.main();
      await tester.pumpAndSettle();

      // 1. Memastikan kita berada di LoginPage
      expect(find.text('Perpustakaan Digital'), findsOneWidget);

      // 2. Klik tombol Daftar Sekarang
      final daftarSekarangBtn = find.text('Daftar Sekarang');
      expect(daftarSekarangBtn, findsOneWidget);
      await tester.tap(daftarSekarangBtn);
      await tester.pumpAndSettle();

      // 3. Berada di halaman Register
      expect(find.text('Buat Akun Baru'), findsOneWidget);

      // 4. Mengisi Form Registrasi
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nama Lengkap'), 'Test User');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'NIK'), '1234567890123456');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'testuser123@gmail.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Alamat'), 'Jl. Testing No. 1');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Nomor Telepon'), '081234567890');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Username'), 'testuser123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');

      // Hide keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // 5. Submit Form Registrasi
      final daftarBtn = find.widgetWithText(FilledButton, 'Daftar');
      // Scroll ke bawah agar tombol Daftar terlihat
      await tester.ensureVisible(daftarBtn);
      await tester.tap(daftarBtn);
      await tester.pumpAndSettle();

      // 6. Kita harusnya kembali ke LoginPage setelah daftar sukses
      expect(find.text('Perpustakaan Digital'), findsOneWidget);

      // 7. Mengisi Form Login
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email atau NIK'),
          'testuser123@gmail.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');
      await tester.pumpAndSettle();

      // 8. Submit Form Login
      final masukBtn = find.widgetWithText(FilledButton, 'Masuk');
      await tester.ensureVisible(masukBtn);
      await tester.tap(masukBtn);
      await tester.pumpAndSettle();

      // 9. Pastikan kita masuk ke HomePage (Ada tulisan Eksplorasi)
      expect(find.text('Eksplorasi'), findsOneWidget);
    });
  });
}
