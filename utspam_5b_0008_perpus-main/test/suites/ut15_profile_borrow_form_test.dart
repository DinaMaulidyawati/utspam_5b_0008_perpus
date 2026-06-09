import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/pages/profile_page.dart';
import 'package:utspam_5b_0008_perpus/pages/borrow_form_page.dart';
import '../support/fixtures.dart';
import '../support/widget_test_helper.dart';

/// UT-15: Profile & Borrow Form Suite
/// Skenario: tampilan profil dan kalkulasi biaya peminjaman.
void main() {
  final user = sampleUser(id: 1, suffix: 'prof');
  final book = sampleBook(id: 1, pricePerDay: 8000);

  group('UT-15 ProfileBorrowFormSuite', () {
    testWidgets('UT-15-001 ProfilePage menampilkan data akun', (tester) async {
      await pumpAppWidget(tester, ProfilePage(user: user));

      expect(find.text('Profil Saya'), findsOneWidget);
      expect(find.text(user.fullName), findsWidgets);
      expect(find.text('@${user.username}'), findsOneWidget);
      expect(find.text(user.nik), findsOneWidget);
      expect(find.text(user.email), findsOneWidget);
    });

    testWidgets('UT-15-002 ProfilePage menampilkan telepon dan alamat', (
      tester,
    ) async {
      await pumpAppWidget(tester, ProfilePage(user: user));

      expect(find.text('Nomor Telepon'), findsOneWidget);
      expect(find.text(user.phone), findsOneWidget);
      expect(find.text('Alamat'), findsOneWidget);
      expect(find.text(user.address), findsOneWidget);
    });

    testWidgets('UT-15-003 BorrowFormPage menampilkan judul buku', (
      tester,
    ) async {
      await pumpAppWidget(tester, BorrowFormPage(user: user, book: book));

      expect(find.text('Form Peminjaman'), findsOneWidget);
      expect(find.text(book.title), findsOneWidget);
      expect(find.text('Konfirmasi Peminjaman'), findsOneWidget);
    });

    testWidgets('UT-15-004 durasi 3 hari menghitung total Rp 24000', (
      tester,
    ) async {
      await pumpAppWidget(tester, BorrowFormPage(user: user, book: book));

      final durationField = find.byType(TextFormField).at(1);
      await tester.enterText(durationField, '3');
      await tester.pump();

      expect(find.text('Rp 24000'), findsOneWidget);
    });

    testWidgets('UT-15-005 durasi kosong gagal validasi', (tester) async {
      await pumpAppWidget(tester, BorrowFormPage(user: user, book: book));

      final durationField = find.byType(TextFormField).at(1);
      await tester.enterText(durationField, '');
      await triggerFormValidation(tester);

      expect(find.text('Lama pinjam wajib diisi'), findsOneWidget);
    });
  });
}
