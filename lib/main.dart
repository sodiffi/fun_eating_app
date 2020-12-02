import 'dart:async';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';


class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
     color: Color.fromRGBO(255, 245, 227, 1),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Image.asset(
           "images/labinhome.png",
           width: 100,
         ),
         FlatButton(
             onPressed: () {
               Navigator.pushNamed(context, '/begin');
             },
             child: Text("開始"))
       ],
     ),
   );
  }

}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(255, 245, 227, 1),
            shape: RoundedRectangleBorder(),
            elevation: 0,
          )),
      home:
      Navigator(
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


      // home:Column(children: [],),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(HomePage());
}
