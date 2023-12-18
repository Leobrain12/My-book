class Book {
  int? id;
  String title;
  String author;
  String genre;
  DateTime date;
  double rating;
  bool isRead;
  String? imageUrl; // Добавлено новое поле для URL-изображения

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.date,
    required this.rating,
    this.isRead = false,
    this.imageUrl, // Обновленный конструктор
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'date': date.toIso8601String(),
      'rating': rating,
      'isRead': isRead ? 1 : 0,
      'imageUrl': imageUrl, // Добавлено в отображение базы данных
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      date: DateTime.parse(map['date']),
      rating: map['rating'],
      isRead: map['isRead'] == 1,
      imageUrl: map['imageUrl'], // Добавлено в отображение базы данных
    );
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? genre,
    DateTime? date,
    double? rating,
    bool? isRead,
    String? imageUrl, // Добавлено в метод copyWith
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      date: date ?? this.date,
      rating: rating ?? this.rating,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl, // Добавлено в метод copyWith
    );
  }
}
