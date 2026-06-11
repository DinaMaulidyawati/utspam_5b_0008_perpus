import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';

/// UT-08: Borrowing Create Suite
/// Skenario: pembuatan record peminjaman baru.
void main() {
  late int userId;
  late int bookId;

  setUpAll(() async {
    await bootstrapTestDatabase('ut08');
    userId = await DatabaseHelper.instance.createUser(
      sampleUser(suffix: 'borrow'),
    );
    final book = await DatabaseHelper.instance.getBookById(1);
    bookId = book!.id!;
  });

  group('UT-08 BorrowingCreateSuite', () {
    test('UT-08-001 createBorrowing mengembalikan id positif', () async {
      final id = await DatabaseHelper.instance.createBorrowing(
        sampleBorrowing(userId: userId, bookId: bookId),
      );
      expect(id, greaterThan(0));
    });

    test('UT-08-002 createBorrowing menyimpan status aktif', () async {
      final id = await DatabaseHelper.instance.createBorrowing(
        sampleBorrowing(
          userId: userId,
          bookId: bookId,
          status: 'aktif',
          totalCost: 16000,
        ),
      );
      final saved = await DatabaseHelper.instance.getBorrowingById(id);
      expect(saved?.status, 'aktif');
    });

    test('UT-08-003 createBorrowing menyimpan totalCost sesuai durasi', () async {
      final id = await DatabaseHelper.instance.createBorrowing(
        sampleBorrowing(
          userId: userId,
          bookId: bookId,
          durationDays: 2,
          totalCost: 16000,
        ),
      );
      final saved = await DatabaseHelper.instance.getBorrowingById(id);
      expect(saved?.durationDays, 2);
      expect(saved?.totalCost, 16000);
    });
  });
}
