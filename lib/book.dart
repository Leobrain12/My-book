enum BookStatus {
  read,
  postponed,
  willReadLater,
}

class Book {
  final int? id;
  final String title;
  final String author;
  final String genre;
  final DateTime date;
  final String imageUrl;
  final String description;
  final BookStatus status;// Добавим поле description

  // Изменим конструктор
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.status,
  });

  // Изменим фабричный метод copyWith
  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? genre,
    DateTime? date,
    String? imageUrl,
    String? description,
    BookStatus? status,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  // Добавим фабричный метод fromMap для создания экземпляра Book из Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      date: DateTime.parse(map['date']),
      imageUrl: map['imageUrl'],
      description: map['description'],
      status: map['status'] != null ? BookStatus.values.firstWhere((e) => e.toString() == 'BookStatus.${map['status']}') : BookStatus.read,
    );
  }

  // Добавим метод toMap для преобразования экземпляра Book в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'description': description,
      'status': _getStatusString(status),
    };
  }
  static String _getStatusString(BookStatus status) {
    switch (status) {
      case BookStatus.read:
        return 'read';
      case BookStatus.postponed:
        return 'postponed';
      case BookStatus.willReadLater:
        return 'willReadLater';
    }
  }
  Book copyWithStatus({
    BookStatus? status,
  }) {
    return Book(
      id: id,
      title: title,
      author: author,
      genre: genre,
      date: date,
      imageUrl: imageUrl,
      description: description,
      status: status ?? this.status,
    );
  }
}
