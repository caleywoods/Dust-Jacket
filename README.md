# Dust Jacket

ISBN Reading Counts Points Finder. This app uses dart barcode_scan to scan a barcode. It's waiting to find an EAN_13 ISBN type barcode like
you would find on the back of a book. Once it finds one, it attempts to send the barcode/ISBN to the google books API to get author and
title information. From there it performs an author search on the Houghton Mifflin Harcourt "Book Expert Online" website which stores
information about whether or not a given book is "quizzable" by kids in elementary schools that use the "reading counts" program.

Once the author search is done, the HTML is then parsed and I gather up a Map of the book titles and their "unique IDs". Unfortunately on
the Houghton Mifflin site there's no end URL you can really visit to get the reading counts points value but they use this unique ID to
do a POST call to an endpoint and then replace data on the initial page. This is why we need the Map of the title and it's "unique ID".

With the Map built I then look to see if the Title we got back earlier from the Google Books API matches any of the titles within the keys
of the Map object (there's some lower casing and removal of spaces that goes on to help fuzzy things just a bit). If no results are found
then we assume a book is worth no points and reflect that back in the UI with a message. If a match is found, we then do the POST over to
the same endpoint that the Houghton Mifflin page uses, sending our "unique id" for this title as "tid" in form data. I then parse the
returned HTML for the point value and return that back to the UI

This is a pet project of mine and the first time I've had any experience with Flutter, Dart, or Android Studio / Android apps. I come from a
javascript/typescript & Angular background and Dart seems very comparable to that. My initial impressions on Dart are good but it did seem
like a lot of the plugins I was reading about seem to lack solid documentation, maybe there's something I am missing.

### Building a release

`flutter build appbundle --release --target-platform=android-arm64`