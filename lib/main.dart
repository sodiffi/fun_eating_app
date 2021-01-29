import 'dart:async';
import 'package:flutter/material.dart';
import 'dataBean.dart';
import 'home.dart';
import 'package:flutter/services.dart';
import 'customeItem.dart';

import 'result.dart';
import 'package:vibration/vibration.dart';

void main() {
  DataBean dataBean=new DataBean();
  dataBean.result=0.3;

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
        Vibration.vibrate(duration: 1000);
        Vibration.cancel();
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
