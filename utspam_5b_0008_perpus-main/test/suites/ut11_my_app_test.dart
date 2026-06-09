import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/main.dart';
import 'package:utspam_5b_0008_perpus/pages/login_page.dart';
import '../support/widget_test_helper.dart';

/// UT-11: MyApp Widget Suite
/// Skenario: konfigurasi aplikasi Material dan halaman awal.
void main() {
  group('UT-11 MyAppSuite', () {
    testWidgets('UT-11-001 MyApp menampilkan judul Perpustakaan Digital', (
      tester,
    ) async {
      await setupLargeTestSurface(tester);
      await tester.pumpWidget(const MyApp());
      await pumpFrames(tester);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Perpustakaan Digital');
    });

    testWidgets('UT-11-002 home awal adalah LoginPage', (tester) async {
      await setupLargeTestSurface(tester);
      await tester.pumpWidget(const MyApp());
      await pumpFrames(tester);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Perpustakaan Digital'), findsOneWidget);
    });

    testWidgets('UT-11-003 debug banner dinonaktifkan', (tester) async {
      await setupLargeTestSurface(tester);
      await tester.pumpWidget(const MyApp());
      await pumpFrames(tester);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });
}
