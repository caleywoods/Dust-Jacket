import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';
import '../models/app_state.dart';

class GoogleBooksAPI {
  // Use google books API to get json response about a book using its ISBN
  static Future<Book> query(String isbn) async {
    String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';
    print(url);

    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    final resp = json.decode(response.body);

    if (response.statusCode == 200) {
      if (resp["totalItems"] == 0) {
        Book book = Book();
        book.isbn = isbn;
        AppState.change(book, false, true);
      } else {
        return Book.fromJson(resp);
      }
    } else {
      throw Exception('Failed to get response from Google API.');
    }
  }
}