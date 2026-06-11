import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import 'package:utspam_5b_0008_perpus/models/borrowing.dart';
import '../support/fixtures.dart';
import '../support/test_bootstrap.dart';

/// UT-10: Borrowing Update Suite
/// Skenario: update status dan data peminjaman penuh.
void main() {
  late int borrowingId;

  setUpAll(() async {
    await bootstrapTestDatabase('ut10');
    final userId = await DatabaseHelper.instance.createUser(
      sampleUser(suffix: 'upd'),
    );
    borrowingId = await DatabaseHelper.instance.createBorrowing(
      sampleBorrowing(userId: userId, bookId: 1),
    );
  });

  group('UT-10 BorrowingUpdateSuite', () {
    test('UT-10-001 updateBorrowingStatus ke selesai', () async {
      await DatabaseHelper.instance.updateBorrowingStatus(
        borrowingId,
        'selesai',
      );
      final saved = await DatabaseHelper.instance.getBorrowingById(
        borrowingId,
      );
      expect(saved?.status, 'selesai');
    });

    test('UT-10-002 updateBorrowingStatus ke dibatalkan', () async {
      await DatabaseHelper.instance.updateBorrowingStatus(
        borrowingId,
        'dibatalkan',
      );
      final saved = await DatabaseHelper.instance.getBorrowingById(
        borrowingId,
      );
      expect(saved?.status, 'dibatalkan');
    });

    test('UT-10-003 updateBorrowing mengubah durationDays dan totalCost', () async {
      final current = await DatabaseHelper.instance.getBorrowingById(
        borrowingId,
      );
      final updated = Borrowing(
        id: current!.id,
        userId: current.userId,
        bookId: current.bookId,
        bookTitle: current.bookTitle,
        bookCover: current.bookCover,
        bookGenre: current.bookGenre,
        bookPricePerDay: current.bookPricePerDay,
        borrowerName: current.borrowerName,
        durationDays: 7,
        startDate: current.startDate,
        totalCost: 56000,
        status: 'aktif',
      );

      final rows = await DatabaseHelper.instance.updateBorrowing(updated);
      expect(rows, 1);

      final saved = await DatabaseHelper.instance.getBorrowingById(borrowingId);
      expect(saved?.durationDays, 7);
      expect(saved?.totalCost, 56000);
    });
  });
}
