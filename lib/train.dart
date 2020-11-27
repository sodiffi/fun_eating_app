// import 'dart:html';

import 'dart:ui';
import 'home.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TrainPage extends StatelessWidget {
  int testTime = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "openhuninn",
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(255, 245, 227, 1),
              shape: RoundedRectangleBorder(),
              elevation: 0,
            )),
        home: Scaffold(
          backgroundColor: Color.fromRGBO(254, 246, 227, 1),
          body: new ListView(children: <Widget>[
            new Image.asset("images/train/step1_pic.png"),
            new Image.asset("images/train/step2_pic.png"),
            new Image.asset("images/train/step3_pic.png"),
            new Image.asset("images/train/step4_pic.png"),
            new Image.asset("images/train/step5_pic.png"),
            new Image.asset("images/train/step6_pic.png"),
            new Image.asset("images/train/step7_pic.png")
          ]),
        ));
  }
}
