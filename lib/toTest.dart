import 'dart:ui';
import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  final Widget body;
  Pages({Key key, @required this.body});

  @override
  PageState createState() {
    return PageState(bb: body);
  }
}

class PageState extends State<Pages> {
  final Color background = Color.fromRGBO(255, 245, 227, 1);
  bool isStraight = false;
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  final Widget bb;
  PageState({Key key, @required this.bb});

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.fromLTRB(
            isStraight ? 5 : iconSize, 5, isStraight ? 5 : iconSize, 5),
        color: background,
        child: bb,
      )),
    );
  }
}
