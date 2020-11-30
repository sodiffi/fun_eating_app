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
      ),
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
    Widget homeButton = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeMenuPage()));
                },
                child: Image.asset(
                  'images/home.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Spacer(flex: 6),
      ],
    );

    Widget buttonTrainBox = (Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TrainPage()));
          },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/trainBox.png',
                width:isStraight?MediaQuery.of(context).size.height * 0.3:MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
              ),
              Text('操作教學')
            ],
          ),
        ),
      ),
    ));
    Widget buttonTestBox = (Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestInputPage()));
            },
            child: Stack(
              alignment: const Alignment(0, 0),
              children: [
                Image.asset(
                  'images/testBox.png',
                  width:isStraight?MediaQuery.of(context).size.height * 0.3:MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.cover,
                ),
                Text('開始檢測')
              ],
            ),
          ),
        ),
      ),
    ));
    

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SizedBox(
        child: Column(
          children: <Widget>[homeButton] +
              (isStraight
                  ? [
                      Container(
                        height:MediaQuery.of(context).size.height * 0.85,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(flex:1,child:buttonTrainBox),
                            Expanded(flex:1,child:buttonTestBox),
                          ],
                        ),
                      ),
                    ]
                  : [
                      Row(
                        children: [buttonTrainBox, buttonTestBox],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ]),
        ),
      ),
    );
  }
}
