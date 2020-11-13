import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/screens.dart';
import 'shared/shared.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark, fontFamily: 'NotoSans'),
        home: new Scaffold(
            body: Container(
              child: HomeScreen(),
            ),
            bottomNavigationBar: NavButtons()));
  }
}
