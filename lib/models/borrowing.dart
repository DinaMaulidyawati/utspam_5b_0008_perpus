class Borrowing {
  int? id;
  int userId;
  int bookId;
  String bookTitle;
  String bookCover;
  String bookGenre;
  double bookPricePerDay;
  String borrowerName;
  int durationDays;
  String startDate;
  double totalCost;
  String status;

  Borrowing({
    this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.bookCover,
    required this.bookGenre,
    required this.bookPricePerDay,
    required this.borrowerName,
    required this.durationDays,
    required this.startDate,
    required this.totalCost,
    this.status = 'aktif',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCover': bookCover,
      'bookGenre': bookGenre,
      'bookPricePerDay': bookPricePerDay,
      'borrowerName': borrowerName,
      'durationDays': durationDays,
      'startDate': startDate,
      'totalCost': totalCost,
      'status': status,
    };
  }

  factory Borrowing.fromMap(Map<String, dynamic> map) {
    return Borrowing(
      id: map['id'],
      userId: map['userId'],
      bookId: map['bookId'],
      bookTitle: map['bookTitle'],
      bookCover: map['bookCover'],
      bookGenre: map['bookGenre'],
      bookPricePerDay: map['bookPricePerDay'],
      borrowerName: map['borrowerName'],
      durationDays: map['durationDays'],
      startDate: map['startDate'],
      totalCost: map['totalCost'],
      status: map['status'] ?? 'aktif',
    );
  }
}
