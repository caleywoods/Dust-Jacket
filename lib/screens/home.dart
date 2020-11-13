import 'package:flutter/material.dart';
import '../models/app_state.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.data == null) {
              return Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/logo.png'),
                        Text('Scan a book',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 50.0))
                      ]));
            }
            return Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snap.data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 25.0)),
                  Text(snap.data.authors[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w100, fontSize: 15.0)),
                  Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image: snap.data.thumbnail))),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(snap.data.points,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 30.0)),
                  )
                ],
              ),
            );
          },
          stream: AppState.stream$,
        ));
  }
}
