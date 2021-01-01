// import 'dart:html';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/testMenu.dart';

// ignore: must_be_immutable
class TrainPage extends StatelessWidget {
  int testTime = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(254, 246, 227, 1),
        body: new ListView(
          children: <Widget>[
            new Image.asset("images/train/step1_pic.png"),
            new Image.asset("images/train/step2_pic.png"),
            new Image.asset("images/train/step3_pic.png"),
            new Image.asset("images/train/step4_pic.png"),
            new Image.asset("images/train/step5_pic.png"),
            new Image.asset("images/train/step6_pic.png"),
            new Image.asset("images/train/step7_pic.png"),
          
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestMenu(),
                  ),
                );
              },
              child: Text("開始檢測"),
            ),
          ],
        ),
      ),
    );
  }
}
