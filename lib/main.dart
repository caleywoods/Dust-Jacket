
import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as DOM;
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";
  String firstAuthor = "";
  String bookTitle = "";
  String bookThumbnail = "https://via.placeholder.com/150";
  String rcAuthorURL = "";
  String rcPoints = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Dust Jacket'),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new MaterialButton(
                      onPressed: scan, child: new Text("Scan A UPC")),
                  padding: const EdgeInsets.all(8.0),
                ),
                new Text(barcode),
                new Text(bookTitle),
                new Text('By: ' + firstAuthor),
                new Image.network(bookThumbnail),
                new MaterialButton(onPressed: launchRCSearchResultsPage, child: new Text("Open RC Search Results Page")),
                new Text('RC! Points: $rcPoints')
              ],
            ),
          )),
    );
  }

  // This handles the UPC / ISBN scanning
  Future scan() async {
    try {
      this.reset();
      String barcode = await BarcodeScanner.scan();
      Book book = await this.queryGoogleBooks(barcode);
      setState(() {
        this.barcode = barcode;
        this.bookTitle = book.title;
        this.firstAuthor = book.authors[0];
        this.bookThumbnail = book.thumbnail;
      });
      this.getBookPoints();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = '$e');
      this.reset();
    }
  }

  // Open the Reading Counts search results page in a browser
  launchRCSearchResultsPage() async {
    String url = this.rcAuthorURL;
    // User hasn't clicked "Fetch RC Points"
    if (url.isEmpty) {
      String criteria = this.serializeCriteria(this.firstAuthor);
      String type = 'Author';
      url = 'https://readingcountsbookexpert.tgds.hmhco.com/bookexpert/search_results_quickfind.asp?criteria=$criteria&type=$type';
    }
    if (await launch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  // type should be 'Author' or 'Title'
  // Criteria would be 'dog+vs.+cat' or 'Chris+Gall', spaces replaced with +
  Future getBookPoints() async {
    String type = 'Author';
    String criteria = this.serializeCriteria(this.firstAuthor);
    String url = 'https://readingcountsbookexpert.tgds.hmhco.com/bookexpert/search_results_quickfind.asp?criteria=$criteria&type=$type';
    // Use this for a "Open RC Search Results" button
    setState(() => this.rcAuthorURL = url);

    var client = http.Client();

    http.Response response = await client.get(url);

    DOM.Document document = parse(response.body);

    // All Book titles on the page are bold so they're <b> elements
    List<DOM.Element> titleElements = document.querySelectorAll('b]');

    // First bold element is always "Quick Find Results:", remove it
    titleElements.removeAt(0);

    Map<String, String> titlesWithIDs = new Map();

    for (var element in titleElements) {
      titlesWithIDs[this.sanitizeHTMLBookTitle(element)] = this.takeUniqueID(element);
    }

    String title = this.sanitizeBookTitle(this.bookTitle);
    if (titlesWithIDs.containsKey(title)) {
      String countsURL = 'https://readingcountsbookexpert.tgds.hmhco.com/bookexpert/detail_title.asp?UID=&subt=0';
      String id = titlesWithIDs[title];
      try {
        http.Response points = await client.post(countsURL, body: {'tid': id});
        DOM.Document pointsBody = parse(points.body);
        var divs = pointsBody.querySelectorAll('#taginfo').map((ele) => ele.innerHtml);
        String thePoints = divs.where((text) => text.contains('Points')).toString();
        thePoints = this.takeNumbers(thePoints);

        setState(() => this.rcPoints = thePoints);
      } finally {
        client.close();
      }

      // POST to https://readingcountsbookexpert.tgds.hmhco.com/bookexpert/detail_title.asp?UID=&subt=0
      // with form data tid: 850076
      // as application/x-www-form-urlencoded
    } else {
      setState(() => this.rcPoints = "Not Found!");
    }
  }

  sanitizeHTMLBookTitle(DOM.Element element) {
    return element.innerHtml.replaceAll(' ', '').toLowerCase();
  }

  sanitizeBookTitle(String title) {
    return title.replaceAll(' ', '').toLowerCase();
  }

  takeUniqueID(DOM.Element element) {
    // Take all digits from a string
    final numeric = RegExp(r"(\d+)");
    // Take the onclick attribute and break the "return false;" off
    // We only care about the numbers inside linkTitle(nnnnnn) which is position zero
    String linkTitle = element.parentNode.attributes['onclick'].split(';')[0];
    String uniqueID = numeric.stringMatch(linkTitle);
    return uniqueID;
  }

  takeNumbers(String input) {
    final numeric = RegExp(r"(\d+)");
    return numeric.stringMatch(input);
  }

  // Take a string with spaces and replace them with + for building the reading counts criteria string
  serializeCriteria(String input) {
    return input.replaceAll(' ', '+');
  }

  reset() {
    setState(() {
      this.bookThumbnail = '';
      this.bookTitle = '';
      this.firstAuthor = '';
      this.rcPoints = '';
    });
  }

  // Use google books API to get json response about a book using its ISBN
  Future<Book> queryGoogleBooks(String isbn) async {

    String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn';
    print(url);

    final response =
    await http.get(url, headers: {"Accept": "application/json"});

    final resp = json.decode(response.body);
    print(resp);

    if (response.statusCode == 200) {
      if (resp["totalItems"] == 0) {
        throw Exception('No Results Found');
      } else {
        return Book.fromJson(resp);
      }
    } else {
      throw Exception('Failed to get response from Google API.');
    }
  }
}

class Book {
  List authors;
  String title;
  String thumbnail;

  Book({this.authors, this.thumbnail, this.title});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        authors: json['items'][0]['volumeInfo']['authors'],
        thumbnail: json['items'][0]['volumeInfo']['imageLinks']['thumbnail'],
        title: json['items'][0]['volumeInfo']['title']);
  }
}