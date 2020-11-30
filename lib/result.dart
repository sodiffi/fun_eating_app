// import 'dart:html';

import 'package:flutter/material.dart';

double rate;
String r;

class ResultPage extends StatelessWidget {
  ResultPage(double rate) {
    rate = rate;
    r = rate.floor().toString() + "%";
  }
  ResultPage.empty() {
    rate = 0;
  }

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
            )),
        home: Result());
  }
}

class ResultState extends State<Result> {
  bool isStraight = false;

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    
    return Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: Image.asset("images/home.png"),
                heroTag: "home",
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Image.asset("images/customerService.png"),
                heroTag: "customerService",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: const Alignment(0.0, -0.1),
                      children: [
                        Image.asset("images/rateBox.png"),
                        Text(
                          r,
                          style: new TextStyle(
                            fontSize: 50,
                          ),
                        )
                      ],
                    )
                  ]),
              Stack(
                alignment: const Alignment(0.0, 0.2),
                children: [
                  Stack(
                    alignment: const Alignment(0.8, -0.8),
                    children: [
                      Image.asset("images/report.png"),
                      Image.asset("images/share.png"),
                    ],
                  ),
                  Text(
                    rate < 35
                        ? "合格"
                        : rate < 45
                            ? "通知供應單位延期採收\n追蹤農民用藥"
                            : "銷毀或\n將樣品送衛生局複檢",
                    style: new TextStyle(fontSize: 45),
                  )
                ],
              ),
            ],
          ),
        ]);
  }
}

// ignore: must_be_immutable

class Result extends StatefulWidget {
  @override
  ResultState createState() {
    return ResultState();
  }
}
