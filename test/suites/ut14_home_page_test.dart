import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/pages/home_page.dart';
import 'package:utspam_5b_0008_perpus/pages/book_list_page.dart';
import 'package:utspam_5b_0008_perpus/pages/borrowing_history_page.dart';
import 'package:utspam_5b_0008_perpus/pages/profile_page.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';
import '../support/widget_test_helper.dart';

/// UT-14: Home Page Suite
/// Skenario: dashboard utama setelah login.
void main() {
  final user = sampleUser(id: 1, suffix: 'home');

  setUpAll(() async {
    await bootstrapTestDatabase('ut14');
  });

  group('UT-14 HomePageSuite', () {
    testWidgets('UT-14-001 menampilkan nama pengguna', (tester) async {
      await pumpAppWidget(tester, HomePage(user: user));

      expect(find.text('Selamat Datang'), findsOneWidget);
      expect(find.text(user.fullName), findsOneWidget);
    });

    testWidgets('UT-14-002 menampilkan menu Eksplorasi dan kartu navigasi', (
      tester,
    ) async {
      await pumpAppWidget(tester, HomePage(user: user));

      expect(find.text('Eksplorasi'), findsOneWidget);
      expect(find.text('Jelajahi Koleksi Buku'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('UT-14-003 tap koleksi buku membuka BookListPage', (
      tester,
    ) async {
      await pumpAppWidget(tester, HomePage(user: user));

      await tapWhenVisible(tester, find.text('Jelajahi Koleksi Buku'));
      await pumpFrames(tester);

      expect(find.byType(BookListPage), findsOneWidget);
      expect(find.text('Daftar Buku'), findsOneWidget);
    });

    testWidgets('UT-14-004 tap Riwayat membuka BorrowingHistoryPage', (
      tester,
    ) async {
      await pumpAppWidget(tester, HomePage(user: user));

      await tapWhenVisible(tester, find.text('Riwayat'));
      await pumpFrames(tester);

      expect(find.byType(BorrowingHistoryPage), findsOneWidget);
      expect(find.text('Riwayat Peminjaman'), findsOneWidget);
    });

    testWidgets('UT-14-005 tap Profil membuka ProfilePage', (tester) async {
      await pumpAppWidget(tester, HomePage(user: user));

      await tapWhenVisible(tester, find.text('Profil'));
      await pumpFrames(tester);

      expect(find.byType(ProfilePage), findsOneWidget);
    });
  });
}
