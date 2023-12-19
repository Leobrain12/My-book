import 'package:flutter/material.dart';
import 'book.dart';
import 'database_helper.dart';
import 'book_list.dart';

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
    BuildContext currentContext = context;

    // Создаем новый экземпляр книги с измененными данными
      Book updatedBook = widget.book.copyWith(
      title: _titleController.text,
      author: _authorController.text,
      genre: _genreController.text,
      description: _descriptionController.text,
    );

    // Обновляем книгу в базе данных
      int result = await DatabaseHelper().updateBook(updatedBook);
    if (result > 0) {
      // Если обновление прошло успешно, закрываем экран редактирования и передаем обновленную книгу
      Navigator.pushReplacement(
        currentContext,
        MaterialPageRoute(
          builder: (context) => BookList(),
          settings: RouteSettings(arguments: updatedBook),
        ),
      );
    } else {
      // Если произошла ошибка при обновлении, выведите сообщение об ошибке или выполните другие действия по вашему усмотрению
      print('Ошибка при обновлении книги в базе данных');
      // Добавьте дополнительную обработку ошибки по вашему усмотрению
    }
  }
}
