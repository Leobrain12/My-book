import 'package:flutter/material.dart';
import 'book.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController(); // Новый контроллер для URL-изображения

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить книгу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Название книги'),
            ),
            TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: 'Автор'),
            ),
            TextField(
              controller: genreController,
              decoration: InputDecoration(labelText: 'Жанр'),
            ),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(labelText: 'Рейтинг'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'URL изображения'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addBook();
              },
              child: Text('Добавить книгу'),
            ),
          ],
        ),
      ),
    );
  }

  void _addBook() {
    if (titleController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        genreController.text.isNotEmpty &&
        ratingController.text.isNotEmpty) {
      var newBook = Book(
        title: titleController.text,
        author: authorController.text,
        genre: genreController.text,
        date: DateTime.now(),
        rating: double.parse(ratingController.text),
        imageUrl: imageUrlController.text, // Присваиваем URL-изображения
      );

      Navigator.pop(context, newBook); // Передача экземпляра книги обратно
    } else {
      // Обработка некорректных данных
    }
  }
}
