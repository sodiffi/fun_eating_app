// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'customeItem.dart';
import 'home.dart';

void main() {
  DataBean dataBean = new DataBean();
  dataBean.result = 0.3;

  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ItemTheme.themeData,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      Duration(seconds: 3),
      (timer) {
        timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => new HomeMenuPage()),
          (Route<dynamic> route) => false,
        );
      },
    );

    return Container(
      color: Color.fromRGBO(255, 245, 227, 1),
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
