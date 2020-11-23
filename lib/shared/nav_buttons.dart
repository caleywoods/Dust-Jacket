import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/app_state.dart';
import '../models/book.dart';
import '../services/services.dart';

class NavButtons extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Container(
                  child: Row(children: <Widget>[
                    IconButton(
                        color: Colors.transparent,
                        icon: Icon(FontAwesomeIcons.book, size: 20),
                        onPressed: () {
                            print('Tapped Books');
                        }),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 75.0
                        ),
                        child: Container(
                          child: Container(
                            height: 110.0,
                            width: 65.0,
                            child: RawMaterialButton(
                              fillColor: Colors.deepPurple[500],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                              child: Icon(FontAwesomeIcons.search, size: 25),
                              onPressed: () async {
                                // @TODO - Make sure we handle errors from UPCScanner elegantly
                                var isbn = await UPCScanner.scan();
                                // Populate UI field for UPC
                                // @TODO - Find a better way to handle isSearching/noSearchResults - don't like having to send empty book
                                AppState.change(Book(), true, false);
                                var book = await GoogleBooksAPI.query(isbn);
                                var parser = DOMParser();
                                var points = await parser.getBookPoints(book.authors[0], book.title);
                                book.setPoints(points);

                                AppState.change(book, false, false);
                              },
                            )
                          ),
                        )
                    ),
                    IconButton(
                        color: Colors.transparent,
                        icon: Icon(FontAwesomeIcons.sun, size: 20),
                        onPressed: () {
                          // @TODO - Implement this -> https://itnext.io/an-easy-way-to-switch-between-dark-and-light-theme-in-flutter-fb971155eefe
                          print('Changed brightness');
                        }
                      ),
                  ]),
                ))
          ],
        )),
      );
  }
}