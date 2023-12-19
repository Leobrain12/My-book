import 'package:flutter/material.dart';
import 'book.dart';
import 'database_helper.dart';
import 'book_list.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  EditBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late BookStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _genreController = TextEditingController(text: widget.book.genre);
    _descriptionController = TextEditingController(text: widget.book.description);
    _imageUrlController = TextEditingController(text: widget.book.imageUrl);
    _selectedStatus = widget.book.status;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название', border: OutlineInputBorder()),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Автор', border: OutlineInputBorder()),
            ),
            TextField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Жанр', border: OutlineInputBorder()),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL изображения', border: OutlineInputBorder()),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft, // Выравнивание текста "Статус" влево
              child: Text(
                'Статус:',
                style: TextStyle(
                  fontSize: 16.0, // Размер шрифта
                  fontWeight: FontWeight.bold, // Жирный шрифт
                  color: Theme.of(context).primaryColor, // Цвет текста (можете настроить под свои цвета)
                ),
              ),
            ),
            DropdownButtonFormField<BookStatus>(
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(
                  value: BookStatus.read,
                  child: Text('Прочитано'),
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
              style: const TextStyle(
                fontSize: 16.0, // Размер шрифта в выпадающем списке
                color: Colors.black, // Цвет текста в выпадающем списке
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Отступы внутри выпадающего списка
                border: OutlineInputBorder(),
              ),
            ),
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
      imageUrl: _imageUrlController.text,
      status: _selectedStatus,
    );

    // Обновляем книгу в базе данных
    int result = await DatabaseHelper().updateBook(updatedBook);

    if (result > 0) {
      // Если обновление прошло успешно, переходим на главную страницу и передаем updatedBook в качестве результата
      Navigator.of(context).pushReplacement(
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
