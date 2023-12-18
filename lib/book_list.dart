import 'package:flutter/material.dart';
import 'add_book_screen.dart';
import 'book.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}
class BookDetailsScreen extends StatelessWidget {
  final Book book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yy.MM.dd HH:mm').format(book.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали книги'),
      ),
      body: SingleChildScrollView( // Оборачиваем в SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 650.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(
                    book.imageUrl ??
                        'https://parpol.ru/wp-content/uploads/2019/09/placeholder.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            buildDetail('Название', book.title),
            buildDetail('Автор', book.author),
            buildDetail('Жанр', book.genre),
            buildDetail('Рейтинг', book.rating.toString()),
            buildDetail('Дата', formattedDate),
          ],
        ),
      ),
    );
  }

  Widget buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class _BookListState extends State<BookList> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final List<Book> loadedBooks = await _databaseHelper.getBooks();

    setState(() {
      books = loadedBooks;
    });
  }

  void _addBook(Book newBook) async {
    // Проверка наличия URL изображения
    if (newBook.imageUrl == null || newBook.imageUrl!.isEmpty) {
      // Если URL отсутствует, используем стандартное изображение
      newBook = newBook.copyWith(
        imageUrl: 'https://parpol.ru/wp-content/uploads/2019/09/placeholder.png',
      );
    }

    int insertedId = await _databaseHelper.insertBook(newBook);
    Book insertedBook = newBook.copyWith(id: insertedId);

    setState(() {
      books.add(insertedBook);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои книги'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                title: Text(
                  books[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(books[index].author),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteBook(books[index]);
                  },
                ),
                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      books[index].imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  _showBookDetails(books[index]);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddBookScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddBookScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBookScreen()),
    );

    if (result != null && result is Book) {
      _addBook(result);
    }
  }

  void _deleteBook(Book book) async {
    await _databaseHelper.deleteBook(book.id!);

    _loadBooks(); // Обновление списка книг после удаления
  }

  void _showBookDetails(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailsScreen(book: book)),
    );
  }
}


