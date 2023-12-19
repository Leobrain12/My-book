import 'package:flutter/material.dart';
import 'add_book_screen.dart';
import 'book.dart';
import 'database_helper.dart';
import 'BookDetailsScreen.dart';
import 'EditBookScreen.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
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
    if (newBook.imageUrl == null || newBook.imageUrl!.isEmpty) {
      newBook = newBook.copyWith(
        imageUrl: 'https://parpol.ru/wp-content/uploads/2019/09/placeholder.png',
      );
    }

    int? insertedId = await _databaseHelper.insertBook(newBook);
    Book insertedBook = newBook.copyWith(id: insertedId);

    setState(() {
      books.add(insertedBook);
    });
  }

  void _deleteBook(Book book) async {
    if (book.id != null) {
      await _databaseHelper.deleteBook(book.id!);
      setState(() {
        books.remove(book);
      });
    }
  }

  void _editBook(Book book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookScreen(book: book),
      ),
    );

    if (result != null && result is Book) {
      // Обновляем список книг после возврата из экрана редактирования
      await _loadBooks();

      // Получаем updatedBook, переданный через параметр arguments
      Book updatedBook = result;
      print('Updated Book: $updatedBook');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои книги'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.5,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                _showBookDetails(books[index], context);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      books[index].imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 270.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          books[index].title.length > 20
                              ? books[index].title.substring(0, 20) + '...'
                              : books[index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          books[index].author.length > 20
                              ? books[index].author.substring(0, 20) + '...'
                              : books[index].author,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddBookScreen();
        },
        child: const Icon(Icons.add),
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

  void _showBookDetails(Book book, BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(
          book: book,
          onDelete: () {
            _deleteBook(book);
          },
        ),
      ),
    );

    if (result != null && result is Book) {
      _editBook(result);
    }
  }
}
