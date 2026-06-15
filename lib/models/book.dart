class Book {
  int? id;
  String title;
  String genre;
  double pricePerDay;
  String coverUrl;
  String synopsis;

  Book({
    this.id,
    required this.title,
    required this.genre,
    required this.pricePerDay,
    required this.coverUrl,
    required this.synopsis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'pricePerDay': pricePerDay,
      'coverUrl': coverUrl,
      'synopsis': synopsis,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      pricePerDay: map['pricePerDay'],
      coverUrl: map['coverUrl'],
      synopsis: map['synopsis'],
    );
  }
}
