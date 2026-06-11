import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';

/// UT-09: Borrowing Query Suite
/// Skenario: pengambilan riwayat peminjaman per pengguna.
void main() {
  late int userId;

  setUpAll(() async {
    await bootstrapTestDatabase('ut09');
    userId = await DatabaseHelper.instance.createUser(
      sampleUser(suffix: 'hist'),
    );
    await DatabaseHelper.instance.createBorrowing(
      sampleBorrowing(userId: userId, bookId: 1, totalCost: 8000),
    );
    await DatabaseHelper.instance.createBorrowing(
      sampleBorrowing(
        userId: userId,
        bookId: 2,
        totalCost: 9000,
        status: 'aktif',
      ),
    );
  });

  group('UT-09 BorrowingQuerySuite', () {
    test('UT-09-001 getBorrowingsByUserId tidak kosong', () async {
      final list = await DatabaseHelper.instance.getBorrowingsByUserId(userId);
      expect(list.length, greaterThanOrEqualTo(2));
    });

    test('UT-09-002 getBorrowingsByUserId diurutkan id DESC', () async {
      final list = await DatabaseHelper.instance.getBorrowingsByUserId(userId);
      if (list.length >= 2) {
        expect(list.first.id! >= list[1].id!, true);
      }
    });

    test('UT-09-003 getBorrowingById mengembalikan judul buku', () async {
      final list = await DatabaseHelper.instance.getBorrowingsByUserId(userId);
      final detail = await DatabaseHelper.instance.getBorrowingById(
        list.first.id!,
      );
      expect(detail?.bookTitle, isNotEmpty);
      expect(detail?.userId, userId);
    });

    test('UT-09-004 getBorrowingById id tidak valid null', () async {
      final detail = await DatabaseHelper.instance.getBorrowingById(99999);
      expect(detail, isNull);
    });
  });
}
