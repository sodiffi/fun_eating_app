// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'customeItem.dart';
import 'home.dart';

void main() { 
  runApp(WelcomePage());
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ItemTheme.themeData,
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new HomePage()),
        (Route<dynamic> route) => false,
      );
    });

    return Container(
      color: ItemTheme.bgColor,
      child: Center(
        child: Image.asset(
          "images/labinhome.png",
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
