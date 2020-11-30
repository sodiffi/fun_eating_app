import 'dart:async';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';



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
      home: Container(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeMenuPage()));
                },
                child: Text("開始"))
          ],
        ),
      ),
      // home:Column(children: [],),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(HomePage());
}
