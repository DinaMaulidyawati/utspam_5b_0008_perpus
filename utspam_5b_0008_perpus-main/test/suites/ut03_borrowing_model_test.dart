import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/models/borrowing.dart';
import '../support/fixtures.dart';

/// UT-03: Borrowing Model Suite
/// Skenario: data peminjaman buku termasuk status default.
void main() {
  group('UT-03 BorrowingModelSuite', () {
    test('UT-03-001 constructor default status adalah aktif', () {
      final borrowing = sampleBorrowing(userId: 1, bookId: 1);
      expect(borrowing.status, 'aktif');
    });

    test('UT-03-002 toMap menyimpan totalCost dan durationDays', () {
      final borrowing = sampleBorrowing(
        userId: 2,
        bookId: 2,
        durationDays: 5,
        totalCost: 40000,
      );
      final map = borrowing.toMap();

      expect(map['durationDays'], 5);
      expect(map['totalCost'], 40000);
      expect(map['status'], 'aktif');
    });

    test('UT-03-003 fromMap status null fallback ke aktif', () {
      final map = {
        'id': 1,
        'userId': 1,
        'bookId': 1,
        'bookTitle': 'A',
        'bookCover': 'c',
        'bookGenre': 'g',
        'bookPricePerDay': 1000.0,
        'borrowerName': 'B',
        'durationDays': 1,
        'startDate': '2026-01-01',
        'totalCost': 1000.0,
      };
      final borrowing = Borrowing.fromMap(map);
      expect(borrowing.status, 'aktif');
    });

    test('UT-03-004 fromMap membaca status selesai dan dibatalkan', () {
      final selesai = Borrowing.fromMap({
        ...sampleBorrowing(userId: 1, bookId: 1, status: 'selesai').toMap(),
        'status': 'selesai',
      });
      final batal = Borrowing.fromMap({
        ...sampleBorrowing(userId: 1, bookId: 1, status: 'dibatalkan').toMap(),
        'status': 'dibatalkan',
      });

      expect(selesai.status, 'selesai');
      expect(batal.status, 'dibatalkan');
    });
  });
}
