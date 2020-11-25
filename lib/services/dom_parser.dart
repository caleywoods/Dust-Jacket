import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as DOM;
import 'package:html/parser.dart';

class DOMParser {

  // type should be 'Author' or 'Title'
  // Criteria would be 'dog+vs.+cat' or 'Chris+Gall', spaces replaced with +
  Future<String> getBookPoints(String firstAuthor, String bookTitle) async {
    String type = 'Author';
    String criteria = this.serializeCriteria(firstAuthor);
    String url =
        'https://readingcountsbookexpert.tgds.hmhco.com/bookexpert/search_results_quickfind.asp?criteria=$criteria&type=$type';

    var client = http.Client();

    http.Response response = await client.get(url);

    DOM.Document document = parse(response.body);

    // All Book titles on the page are bold so they're <b> elements
    List<DOM.Element> titleElements = document.querySelectorAll('.colCenter b');

    // First bold element is always "Quick Find Results:", remove it
    titleElements.removeAt(0);

    Map<String, String> titlesWithIDs = new Map();

    for (var element in titleElements) {
      titlesWithIDs[this.sanitizeHTMLBookTitle(element)] =
          this.takeUniqueID(element);
    }

    String title = this.sanitizeBookTitle(bookTitle);

    if (titlesWithIDs.containsKey(title)) {
      String countsURL =
          'https://readingcountsbookexpert.tgds.hmhco.com/bookexpert/detail_title.asp?UID=&subt=0';
      String id = titlesWithIDs[title];
      try {
        http.Response points = await client.post(countsURL, body: {'tid': id});
        DOM.Document pointsBody = parse(points.body);
        var divs =
            pointsBody.querySelectorAll('#taginfo').map((ele) => ele.innerHtml);
        String thePoints =
            divs.where((text) => text.contains('Points')).toString();
        thePoints = this.takeNumbers(thePoints);

        return thePoints;
      } finally {
        client.close();
      }
    } else {
      return "0";
    }
  }

  // Take a string with spaces and replace them with + for building the reading counts criteria string
  serializeCriteria(String input) {
    return input.replaceAll(' ', '+');
  }

  sanitizeHTMLBookTitle(DOM.Element element) {
    String html = element.innerHtml;
    html = html
        .replaceAll(' ', '')
        .replaceAll('!', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll("'", '')
        .replaceAll('-', '')
        .toLowerCase();

    html = removeArticles(html, true);

    return html;
  }

  sanitizeBookTitle(String title) {
    title = title
        .replaceAll(' ', '')
        .replaceAll('!', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll("'", '')
        .replaceAll('-', '')
        .toLowerCase();

    title = removeArticles(title, false);

    return title;
  }

  removeArticles(String input, bool trailing) {

    if (trailing) {
        bool titleEndsWithArticle = input.substring(input.length - 3) == 'the';
        if (titleEndsWithArticle) {
          // Remove "the" from the end, it messes up finding books
          input = input.substring(0, input.length - 3);
        }
    } else {
        bool titleStartsWithArticle = input.substring(0, 3) == 'the';
        if (titleStartsWithArticle) {
          // Remove "the" from the end, it messes up finding books
          input = input.substring(3);
        }
    }
    return input;
  }

  takeUniqueID(DOM.Element element) {
    // Take all digits from a string
    final numeric = RegExp(r"(\d+)");
    // Take the onclick attribute and break the "return false;" off
    // We only care about the numbers inside linkTitle(nnnnnn) which is position zero
    DOM.Element parent = element.parentNode as DOM.Element;
    String uniqueID = numeric.stringMatch(parent.outerHtml);
    return uniqueID;
  }

  takeNumbers(String input) {
    final numeric = RegExp(r"(\d+)");
    return numeric.stringMatch(input);
  }
}