// import 'dart:html';

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'input.dart';
import 'train.dart';
import 'input.dart';
import 'package:flutter_better_camera/camera.dart';

// ignore: must_be_immutable
class TestMenuPage extends StatefulWidget {
  @override
  _TestMenuPageState createState() => _TestMenuPageState();
}

class _TestMenuPageState extends State<TestMenuPage> {
  int testTime = 5;
  bool isStraight = false;

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });

    if (isStraight) {
      return Container(
        color: Color.fromRGBO(255, 245, 227, 1),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Spacer(flex: 1),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {},
                      child: Image.asset(
                        'images/home.png',
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 8),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: Container(
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TrainPage()));
                    },
                    child: Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        Image.asset(
                          'images/trainBox.png',
                          width: 200.0,
                          fit: BoxFit.fill,
                        ),
                        Text('操作教學')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestInputPage()));
                    },
                    child: Stack(
                      alignment: const Alignment(0, 0),
                      children: [
                        Image.asset(
                          'images/testBox.png',
                          width: 200.0,
                          fit: BoxFit.fill,
                        ),
                        Text('開始檢測')
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "openhuninn",
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(255, 245, 227, 1),
              shape: RoundedRectangleBorder(),
              elevation: 0,
            )),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => TrainPage()));
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
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => TestInputPage()));
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
                    ),
                  ],
                ),
              ]),
        ),
      );
    }
  }
}

class TestMenu extends StatelessWidget {
  int testTime = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 245, 227, 1),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {},
                  child: Image.asset(
                    'images/home.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
              Spacer(flex: 8),
            ],
          ),
          Center(
            child: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrainPage()));
              },
              child: Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Image.asset(
                    'images/trainBox.png',
                    width: 250,
                  ),
                  Text('操作教學')
                ],
              ),
            ),
          ),
          Center(
            child: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TestInputPage()));
              },
              child: Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Image.asset(
                    'images/testBox.png',
                    width: 250,
                  ),
                  Text('開始檢測')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
