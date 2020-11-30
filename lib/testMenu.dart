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
    Widget homeButton = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 0, 0),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeMenuPage()));
              },
              child: Image.asset(
                'images/home.png',
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Spacer(flex: 5),
      ],
    );

    List<Widget> buttons = [
      Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: FlatButton(
              padding: EdgeInsets.zero,
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
          )),
      Padding(
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
                    width: 200.0,
                    fit: BoxFit.fill,
                  ),
                  Text('開始檢測')
                ],
              ),
            ),
          ),
        ),
      )
    ];
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });

    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          homeButton,
          isStraight
              ? Column(
                  children: buttons,
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              : Row(
                  children: buttons,
                  mainAxisAlignment: MainAxisAlignment.center,
                )
        ],
      ),
    );
  }
}
