import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/result.dart';
import 'package:flutter_app/test.dart';

class _HomeState extends State<Home> with WidgetsBindingObserver {
  CameraController controller;
  bool enableAudio = true;
  bool isStraight=false;

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
    this.setState(() {
      isStraight=MediaQuery.of(context).orientation==Orientation.portrait;
    });
    if(this.isStraight){
      return Scaffold(
          body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FloatingActionButton(onPressed: (){},
                        child: Image.asset("images/home.png"),
                        heroTag: "home",
                      ),
                      FloatingActionButton(onPressed: (){},
                        child: Image.asset("images/setting.png"),
                        heroTag: "setting",),

                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Result(20)),
                            );
                          },
                          child: Text("點我跳報告畫面"))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        child: Image.asset('images/train.png', width: 200),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraApp()),
                          );
                        },
                        padding: EdgeInsets.zero,
                        child: Image.asset('images/test.png', width: 200),
                      ),

                    ],
                  ),Column(
                    children: [
                      FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        child: Image.asset('images/knowledge.png', width: 200),
                      ),
                      FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        child: Image.asset('images/record.png', width: 200),
                      )
                    ],
                  )
                ],
              ));
    }
    else{
      return Scaffold(
          body: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FloatingActionButton(onPressed: (){},
                        child: Image.asset("images/home.png"),
                        heroTag: "home",
                      ),
                      FloatingActionButton(onPressed: (){},
                        child: Image.asset("images/setting.png"),
                        heroTag: "setting",),

                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Result(20)),
                            );
                          },
                          child: Text("點我跳報告畫面"))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        padding: EdgeInsets.fromLTRB(25, 50, 0, 0),
                        child: Image.asset('images/train.png', width: 200),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraApp()),
                          );
                        },
                        padding: EdgeInsets.fromLTRB(0, 50, 25, 0),
                        child: Image.asset('images/test.png', width: 200),
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {},
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: Image.asset('images/knowledge.png', width: 200),
                          ),
                          FlatButton(
                            onPressed: () {},
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Image.asset('images/record.png', width: 200),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )));
    }

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

// List<CameraDescription> cameras = [];

Future<void> main() async {
  print("enter main main");
  runApp(HomePage());
}
