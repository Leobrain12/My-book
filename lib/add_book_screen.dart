import 'package:flutter/material.dart';
import 'book.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  BookStatus _selectedStatus = BookStatus.read; // Инициализация статуса

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить книгу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Автор'),
            ),
            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Жанр'),
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL изображения'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 16.0),
            const Text('Статус:'),
            DropdownButtonFormField<BookStatus>(
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(
                  value: BookStatus.read,
                  child: Text('Прочтино'),
                ),
                DropdownMenuItem(
                  value: BookStatus.postponed,
                  child: Text('Отложено'),
                ),
                DropdownMenuItem(
                  value: BookStatus.willReadLater,
                  child: Text('Прочитаю позднее'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveBook();
              },
              child: Text('Сохранить книгу'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBook() {
    // Получите значения из контроллеров и создайте экземпляр Book
    String title = _titleController.text;
    String author = _authorController.text;
    String genre = _genreController.text;
    String imageUrl = _imageUrlController.text;
    String description = _descriptionController.text;

    // Создайте новый экземпляр Book с выбранным статусом
    Book newBook = Book(
      id: null, // Передайте null, чтобы база данных смогла присвоить ID
      title: title,
      author: author,
      genre: genre,
      date: DateTime.now(),
      imageUrl: imageUrl,
      description: description,
      status: _selectedStatus,
    );

    // Отправьте новую книгу обратно на предыдущий экран
    Navigator.pop(context, newBook);
  }
}
