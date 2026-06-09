import 'package:utspam_5b_0008_perpus/models/user.dart';
import 'package:utspam_5b_0008_perpus/models/book.dart';
import 'package:utspam_5b_0008_perpus/models/borrowing.dart';

User sampleUser({
  int? id,
  String suffix = 'a',
}) {
  return User(
    id: id,
    fullName: 'Pengguna Test $suffix',
    nik: '320101010101${suffix.hashCode.abs() % 10000}'.padLeft(16, '0').substring(0, 16),
    email: 'user_$suffix@gmail.com',
    address: 'Jl. Test No. 1',
    phone: '081234567890',
    username: 'user_$suffix',
    password: 'secret123',
  );
}

Book sampleBook({
  int? id,
  double pricePerDay = 8000,
}) {
  return Book(
    id: id,
    title: 'Clean Code',
    genre: 'Programming',
    pricePerDay: pricePerDay,
    coverUrl: 'https://example.com/cover.jpg',
    synopsis: 'Buku tentang kode bersih.',
  );
}

Borrowing sampleBorrowing({
  int? id,
  required int userId,
  required int bookId,
  String status = 'aktif',
  int durationDays = 3,
  double totalCost = 24000,
}) {
  return Borrowing(
    id: id,
    userId: userId,
    bookId: bookId,
    bookTitle: 'Clean Code',
    bookCover: 'https://example.com/cover.jpg',
    bookGenre: 'Programming',
    bookPricePerDay: 8000,
    borrowerName: 'Pengguna Test',
    durationDays: durationDays,
    startDate: '2026-06-01T00:00:00.000',
    totalCost: totalCost,
    status: status,
  );
}
