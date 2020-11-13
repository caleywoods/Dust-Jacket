class Book {
  List authors;
  String title;
  String thumbnail;
  String points;

  Book({this.authors, this.thumbnail, this.title, this.points});

  factory Book.fromJson(Map<String, dynamic> json) {
    bool thumbnailMissing = json['items'][0]['volumeInfo']['imageLinks'] == null;
    String thumbnailOrDefault = thumbnailMissing
      ? 'https://i.imgur.com/OOhQueu.jpg'
      : json['items'][0]['volumeInfo']['imageLinks']['thumbnail'];


    return Book(
      authors: json['items'][0]['volumeInfo']['authors'],
      thumbnail: thumbnailOrDefault,
      title: json['items'][0]['volumeInfo']['title']
    );
  }

  setPoints(String points) {
    int intPoints = int.parse(points);
    String pointsWord = intPoints == 1 ? ' Point' : ' Points';

    this.points = points + pointsWord;
  }
}