import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/pages/register_page.dart';
import 'package:utspam_5b_0008_perpus/pages/login_page.dart';
import '../support/widget_test_helper.dart';

/// UT-13: Register Page Validation Suite
/// Skenario: validasi form registrasi pengguna baru.
void main() {
  group('UT-13 RegisterPageSuite', () {
    testWidgets('UT-13-001 menampilkan form registrasi lengkap', (
      tester,
    ) async {
      await pumpAppWidget(tester, const RegisterPage());

      expect(find.text('Buat Akun Baru'), findsOneWidget);
      expect(find.text('Nama Lengkap'), findsOneWidget);
      expect(find.text('NIK'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    });

    testWidgets('UT-13-002 NIK kurang dari 16 digit ditolak', (tester) async {
      await pumpAppWidget(tester, const RegisterPage());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), '12345');
      await triggerFormValidation(tester);

      expect(find.text('NIK harus 16 digit'), findsOneWidget);
    });

    testWidgets('UT-13-003 email non-gmail ditolak', (tester) async {
      await pumpAppWidget(tester, const RegisterPage());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(2), 'user@yahoo.com');
      await triggerFormValidation(tester);

      expect(
        find.text('Email harus menggunakan @gmail.com'),
        findsOneWidget,
      );
    });

    testWidgets('UT-13-004 username kurang dari 4 karakter ditolak', (
      tester,
    ) async {
      await pumpAppWidget(tester, const RegisterPage());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(5), 'abc');
      await triggerFormValidation(tester);

      expect(find.text('Username minimal 4 karakter'), findsOneWidget);
    });

    testWidgets('UT-13-005 password kurang dari 6 karakter ditolak', (
      tester,
    ) async {
      await pumpAppWidget(tester, const RegisterPage());

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(6), '12345');
      await triggerFormValidation(tester);

      expect(find.text('Password minimal 6 karakter'), findsOneWidget);
    });

    testWidgets('UT-13-006 tombol Login kembali ke LoginPage', (tester) async {
      await pumpAppWidget(tester, const RegisterPage());

      await tapWhenVisible(tester, find.text('Login'));
      await pumpFrames(tester);

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
