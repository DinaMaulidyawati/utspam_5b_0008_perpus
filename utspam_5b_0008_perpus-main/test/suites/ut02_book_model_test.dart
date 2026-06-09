import 'package:flutter_test/flutter_test.dart';
import 'package:utspam_5b_0008_perpus/models/book.dart';
import '../support/fixtures.dart';

/// UT-02: Book Model Suite
/// Skenario: representasi data buku untuk katalog perpustakaan.
void main() {
  group('UT-02 BookModelSuite', () {
    test('UT-02-001 toMap menyimpan harga per hari sebagai numerik', () {
      final book = sampleBook(id: 1, pricePerDay: 8500);
      final map = book.toMap();

      expect(map['title'], 'Clean Code');
      expect(map['pricePerDay'], 8500);
      expect(map['genre'], 'Programming');
    });

    test('UT-02-002 fromMap membaca buku dari baris SQLite', () {
      final book = Book.fromMap({
        'id': 3,
        'title': 'Deep Learning',
        'genre': 'AI & Machine Learning',
        'pricePerDay': 10000.0,
        'coverUrl': 'https://example.com/dl.jpg',
        'synopsis': 'Pengantar deep learning.',
      });

      expect(book.id, 3);
      expect(book.title, 'Deep Learning');
      expect(book.pricePerDay, 10000.0);
    });

    test('UT-02-003 round-trip tidak mengubah sinopsis dan coverUrl', () {
      final book = sampleBook(id: 7);
      final restored = Book.fromMap(book.toMap());

      expect(restored.synopsis, book.synopsis);
      expect(restored.coverUrl, book.coverUrl);
    });
  });
}
