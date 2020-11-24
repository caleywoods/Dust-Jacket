# Dust Jacket
ISBN Reading Counts point finder for Android

<img src="https://i.imgur.com/WIVp68D.png" width="50" height="50">

### What is Reading Counts?
Many schools utilize the ["Reading Counts"](https://www.hmhco.com/programs/reading-counts) literacy program to help build reading comprehension for Elementary aged kids. Kids are typically given a monthly points quota to meet or exceed that increases with grade level.

### Why use this app?

* The "workflow" of the Reading Counts process is clunky and suboptimal

The workflow for Reading Counts is that a child or teacher would select a book they might be interested in reading and then visit the [Book Expert Online](http://readingcountsbookexpert.tgds.hmhco.com/bookexpert/default.asp?UID=2036DF22E95E4D5FA7D73A75C19FB33F&subt=0&Test=NA) database where they would search by book title or author and then be presented with a list of results. They would then need to visually scan these results looking for the book title that they had selected in the classroom or library. If they were able to locate the book in the list, they click it and are taken to a results page that displays the number of points that the student can obtain on passing the 10 question quiz about the book. If they're unable to locate the book in the results list this means that HMH doesn't provide a quiz for the book and therefore no points can be gained towards their quota and they will have to select a different book and repeat the process.

* Enter a better way

This app is designed to save time for student and teacher alike. To retrieve the number of Reading Counts points that might be associated with a book, you only need to launch this app, tap the big purple button, and scan the barcode on the back of the book. The app will do all of the "heavy lifting" of using the ISBN to find the author, doing an author search on the Reading Counts site, and returning the points value back to the app or showing zero if the title isn't found in the Reading Counts database.

### Examples

<img src="https://i.imgur.com/i5UNFg7.png" width="150" height="267">
<img src="https://i.imgur.com/JZKnQ80.png" width="150" height="267">
<img src="https://i.imgur.com/VX7uCJ5.png" width="150" height="267">

### Building a release

`flutter build appbundle --release --target-platform=android-arm64`