// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'input.dart';
import 'train.dart';
import 'home.dart';

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

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    double sizeHeight = isStraight
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    Widget buttonTrainBox = (Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.zero,
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TrainPage()));
          },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/trainBox.png',
                width: isStraight
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.5,
                height: isStraight
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
              ),
              Text('操作教學')
            ],
          ),
        ),
      ),
    ));
    Widget buttonTestBox = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.zero,
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TestInputPage()));
          },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/testBox.png',
                width: isStraight
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.5,
                height: isStraight
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
              ),
              Text('開始檢測')
            ],
          ),
        ),
      ),
    );

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SizedBox(
        child: Column(
          children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        // child: AspectRatio(
                        //   aspectRatio: 1 / 1,
                        //   child: FlatButton(
                        //     padding: EdgeInsets.zero,
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => HomeMenuPage()));
                        //     },
                        //     child: Image.asset(
                        //       'images/home.png',
                        //       height: 50,
                        //       width: 50,
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ),
                        // ),
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
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
                        ),
                      ),
                    ),
                    Spacer(flex: isStraight ? 5 : 6),
                  ],
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
    );
  }
}
