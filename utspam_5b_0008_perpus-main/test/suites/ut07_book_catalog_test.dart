import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import '../support/test_bootstrap.dart';

/// UT-07: Book Catalog Suite
/// Skenario: operasi baca katalog buku dari database.
void main() {
  setUpAll(() async {
    await bootstrapTestDatabase('ut07');
  });

  group('UT-07 BookCatalogSuite', () {
    test('UT-07-001 getAllBooks mengembalikan list tidak kosong', () async {
      final books = await DatabaseHelper.instance.getAllBooks();
      expect(books, isNotEmpty);
    });

    test('UT-07-002 getBookById mengembalikan buku yang valid', () async {
      final books = await DatabaseHelper.instance.getAllBooks();
      final firstId = books.first.id!;

      final book = await DatabaseHelper.instance.getBookById(firstId);
      expect(book, isNotNull);
      expect(book!.id, firstId);
    });

    test('UT-07-003 getBookById id tidak ada mengembalikan null', () async {
      final book = await DatabaseHelper.instance.getBookById(99999);
      expect(book, isNull);
    });

    test('UT-07-004 semua buku memiliki coverUrl dan synopsis', () async {
      final books = await DatabaseHelper.instance.getAllBooks();
      for (final book in books) {
        expect(book.coverUrl, startsWith('https://'));
        expect(book.synopsis.length, greaterThan(10));
      }
    });
  });
}
