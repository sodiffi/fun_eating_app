// import 'dart:html';

import 'package:flutter/material.dart';
import 'train.dart';
import 'input.dart';
import 'package:flutter_better_camera/camera.dart';


// ignore: must_be_immutable
class TestMenuPage extends StatelessWidget {
  int testTime=5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "openhuninn",
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          shape: RoundedRectangleBorder(),
          elevation: 0,
        )
      ),
      home: Scaffold(
        backgroundColor: Color.fromRGBO(254, 246, 227, 1),
        body: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {},
                        child: Image.asset("images/home.png"),
                        heroTag: "home",
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (content)=>TrainPage()));
                          },
                          child: Stack(
                            alignment: const Alignment(0, 0),
                            children: [
                              Image.asset(
                                "images/trainBox.png",
                                width: 250,
                              ),
                              Text("操作教學")
                            ],
                          )),FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (content)=>TestInputPage()));
                          },
                          child: Stack(
                            alignment: const Alignment(0, 0),
                            children: [
                              Image.asset(
                                "images/testBox.png",
                                width: 250,
                              ),
                              Text("開始檢測")
                            ],
                          ))
                    ],
                  )
                  ,
                ],
              ),
            ]),
      ),
    );
  }
}
