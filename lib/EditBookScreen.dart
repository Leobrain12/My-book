import 'package:flutter/material.dart';
import 'book.dart';
import 'database_helper.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  EditBookScreen({super.key, required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _genreController = TextEditingController(text: widget.book.genre);
    _descriptionController = TextEditingController(text: widget.book.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование книги'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Автор'),
            ),
            TextField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Жанр'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    // Создаем новый экземпляр книги с измененными данными
    Book updatedBook = widget.book.copyWith(
      title: _titleController.text,
      author: _authorController.text,
      genre: _genreController.text,
      description: _descriptionController.text,
    );

    // Обновляем книгу в базе данных
      await DatabaseHelper().updateBook(updatedBook);
      Navigator.pop(context, updatedBook);
  }
}
