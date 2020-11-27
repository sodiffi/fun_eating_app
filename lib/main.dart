import 'dart:async';
import 'dart:io';
import 'package:flutter_app/test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/result.dart';
import 'package:flutter_app/home.dart';

class _HomeState extends State<Home> with WidgetsBindingObserver {
  CameraController controller;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(timer.tick==5){
        Navigator.push(
            context,MaterialPageRoute(builder: (context)=>HomeMenuPage())
        );
      }
    });
    return Scaffold(
          body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child:Expanded(child: Image.asset("images/labinhome.png",width: 100,),)

                      // FlatButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => Result(20)),
                      //       );
                      //     },
                      //     child: Text("點我跳報告畫面"))

                  ),

                ],
              ));


  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(
              scaffoldBackgroundColor: Color.fromRGBO(254, 246, 227, 1)
          ,floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(255, 245, 227, 1),
            shape: RoundedRectangleBorder(),
            elevation: 0,
          )),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

List<CameraDescription> cameras = [];

Future<void> main() async {
  runApp(HomePage());
}
