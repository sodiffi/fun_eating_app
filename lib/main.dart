import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/itemTheme.dart';
import 'package:flutter_app/inputN.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      theme: ItemTheme.themeData,
      home: Navigator(
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (_) => Home();
              break;
            case '/begin':
              builder = (_) => HomeMenuPage();
              break;

            default:
              throw new Exception('路由名稱有誤: ${settings.name}');
          }
          return new MaterialPageRoute(builder: builder, settings: settings);
        },
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
        print("timer");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/begin', (Route<dynamic> route) => false);
        timer.cancel();
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
