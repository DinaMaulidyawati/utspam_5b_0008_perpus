import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import 'package:utspam_5b_0008_perpus/pages/login_page.dart';
import 'package:utspam_5b_0008_perpus/pages/register_page.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';
import '../support/widget_test_helper.dart';

/// UT-12: Login Page Suite
/// Skenario: validasi form dan autentikasi pengguna.
void main() {
  setUp(() async {
    await bootstrapTestDatabase('ut12');
    await DatabaseHelper.instance.createUser(sampleUser(suffix: 'login'));
  });

  group('UT-12 LoginPageSuite', () {
    testWidgets('UT-12-001 menampilkan field Email/NIK dan Password', (
      tester,
    ) async {
      await pumpAppWidget(tester, const LoginPage());

      expect(find.text('Email atau NIK'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
    });

    testWidgets('UT-12-002 validasi field kosong menampilkan pesan', (
      tester,
    ) async {
      await pumpAppWidget(tester, const LoginPage());
      await triggerFormValidation(tester);

      expect(find.text('Email atau NIK wajib diisi'), findsOneWidget);
      expect(find.text('Password wajib diisi'), findsOneWidget);
    });

    testWidgets('UT-12-003 login gagal password salah', (tester) async {
      await pumpAppWidget(tester, const LoginPage());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'user_login@gmail.com');
      await tester.enterText(fields.at(1), 'salah');
      await tapWhenVisible(
        tester,
        find.widgetWithText(FilledButton, 'Masuk'),
      );
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await pumpFrames(tester, frames: 4);

      expect(find.text('Email/NIK atau password salah!'), findsOneWidget);
    });

    testWidgets('UT-12-004 login sukses navigasi ke HomePage', (tester) async {
      await pumpAppWidget(tester, const LoginPage());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'user_login@gmail.com');
      await tester.enterText(fields.at(1), 'secret123');
      await tapWhenVisible(
        tester,
        find.widgetWithText(FilledButton, 'Masuk'),
      );
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await pumpFrames(tester, frames: 6);

      expect(find.text('Selamat Datang'), findsOneWidget);
      expect(find.text('Pengguna Test login'), findsOneWidget);
    });

    testWidgets('UT-12-005 tombol Daftar navigasi ke RegisterPage', (
      tester,
    ) async {
      await pumpAppWidget(tester, const LoginPage());

      await tapWhenVisible(tester, find.text('Daftar Sekarang'));
      await pumpFrames(tester);

      expect(find.byType(RegisterPage), findsOneWidget);
      expect(find.text('Buat Akun Baru'), findsOneWidget);
    });
  });
}
