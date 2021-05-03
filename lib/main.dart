// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'home.dart';

void main() {
  DataBean dataBean = new DataBean();
  dataBean.result = 0.3;

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
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomeMenuPage(),
            ),
          ),
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
