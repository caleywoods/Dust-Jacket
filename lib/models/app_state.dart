import 'package:rxdart/rxdart.dart';
import 'book.dart';

class AppState {
  static BehaviorSubject _state = BehaviorSubject<Map>();

  static Observable get stream$ => _state.stream;
  static Book get current => _state.value;

  static change(Book book, isSearching, noSearchResults) {
    Map newState = Map();
    newState['isSearching'] = isSearching;
    newState['scanResults'] = book;
    newState['noSearchResults'] = noSearchResults;
    _state.add(newState);
  }
}