import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/helpers/database_helper.dart';
import '../support/test_bootstrap.dart';

/// UT-04: Database Initialization Suite
/// Skenario: inisialisasi SQLite dan seed data buku dummy.
void main() {
  setUpAll(() async {
    await bootstrapTestDatabase('ut04');
  });

  group('UT-04 DatabaseInitSuite', () {
    test('UT-04-001 database terbuka setelah inisialisasi', () async {
      final db = await DatabaseHelper.instance.database;
      expect(db.isOpen, true);
    });

    test('UT-04-002 tabel books terisi 10 buku seed', () async {
      final books = await DatabaseHelper.instance.getAllBooks();
      expect(books.length, 10);
      expect(books.first.title, isNotEmpty);
    });

    test('UT-04-003 buku seed memiliki genre dan harga valid', () async {
      final books = await DatabaseHelper.instance.getAllBooks();
      final cleanCode = books.firstWhere((b) => b.title == 'Clean Code');

      expect(cleanCode.genre, 'Programming');
      expect(cleanCode.pricePerDay, greaterThan(0));
      expect(cleanCode.synopsis, isNotEmpty);
    });
  });
}
