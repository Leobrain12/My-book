import 'package:flutter/material.dart';
import 'book.dart';
import 'EditBookScreen.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class BookDetailsScreen extends StatefulWidget {
  Book book;
  final VoidCallback onDelete;

  BookDetailsScreen({required this.book, required this.onDelete });

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yy.MM.dd HH:mm').format(widget.book.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали книги'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _onDelete();
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEditBookScreen(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                widget.book.imageUrl ??
                    'https://parpol.ru/wp-content/uploads/2019/09/placeholder.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildDetail('Название', widget.book.title),
            _buildDetail('Автор', widget.book.author),
            _buildDetail('Жанр', widget.book.genre),
            _buildDetail('Описание', widget.book.description),
            _buildDetail('Дата', formattedDate),
            _buildDetail('Статус', _getStatusText(widget.book.status)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
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
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  String _getStatusText(BookStatus status) {
    switch (status) {
      case BookStatus.read:
        return 'Прочтено';
      case BookStatus.postponed:
        return 'Отложено';
      case BookStatus.willReadLater:
        return 'Прочитаю позже';
      default:
        return 'Неизвестный статус';
    }
  }

  void _navigateToEditBookScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookScreen(book: widget.book),
      ),
    );

    if (result != null && result is Book) {
      setState(() {
        widget.book = result;
      });
    }
  }

  void _onDelete() async {
    await DatabaseHelper().deleteBook(widget.book.id!);
    widget.onDelete();
  }
}
