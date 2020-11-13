import 'package:rxdart/rxdart.dart';
import 'book.dart';

class AppState {
  static BehaviorSubject _bookScanResults = BehaviorSubject<Book>();

  static Observable get stream$ => _bookScanResults.stream;
  static Book get current => _bookScanResults.value;

  static change(Book book) {
    _bookScanResults.add(book);
  }
}