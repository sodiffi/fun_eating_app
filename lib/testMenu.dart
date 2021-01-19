// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'input.dart';
import 'train.dart';
import 'home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'itemTheme.dart';

class TestMenu extends StatefulWidget {
  @override
  _TestMenuPageState createState() => _TestMenuPageState();
}

class TestMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestMenu(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          fontFamily: "openhuninn",
          textTheme: TextTheme(
              button: TextStyle(
            fontSize: 35,
          ))),
    );
  }
}

class _TestMenuPageState extends State<TestMenu> {
  bool isStraight = false;
  double imgW = 0;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      imgW = isStraight ? sizeHeight * 0.3 : sizeWidth * 0.5;
    });
    Widget buttonTrainBox = (Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/trainBox.png',
                width: imgW,
                height: imgW,
                fit: BoxFit.cover,
              ),
              AutoTextChange(
                w: imgW,
                s: "操作教學",
                paddingW: imgW * 0.14,
                paddingH: imgW * 0.14,
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TrainPage()));
          },
        ),
      ),
    ));
    Widget buttonTestBox = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TestInputPage()));
          },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/testBox.png',
                width: imgW,
                height: imgW,
                fit: BoxFit.cover,
              ),
              AutoTextChange(
                w: imgW,
                s: "開始檢測",
                paddingW: imgW * 0.14,
                paddingH: imgW * 0.14,
              )
              // Text('開始檢測',style: Theme.of(context).textTheme.subtitle1,)
            ],
          ),
        ),
      ),
    );

    return SafeArea(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SizedBox(
          child: Column(
            children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeMenuPage()));
                          },
                          child: Image.asset(
                            'images/home.png',
                            height: isStraight ? 50 : sizeHeight * 0.15,
                            width: isStraight ? 50 : sizeHeight * 0.15,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  )
                ] +
                (isStraight
                    ? [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              Spacer(flex: 1),
                              Expanded(
                                flex: 9,
                                child: Column(
                                  children: [
                                    buttonTrainBox,
                                    buttonTestBox,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.02),
                                child: buttonTrainBox),
                            Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.02),
                                child: buttonTestBox)
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ]),
          ),
        ),
      ),
    );
  }
}
