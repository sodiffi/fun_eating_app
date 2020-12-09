// import 'dart:html';
import 'package:flutter_app/screenArgs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';

String rate = "0%";
String content = "合格";
double result;

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScreenArgs args = ModalRoute.of(context).settings.arguments;
    result = args.result;
    rate = result.floor().toString() + "%";
    if (result <= 35)
      content = "合格";
    else if (result <= 45)
      content = "通知供應單位延期採收\n追蹤農民用藥";
    else
      content = "銷毀或\n將樣品送衛生局複檢";
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          fontFamily: "openhuninn",
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(255, 245, 227, 1),
            shape: RoundedRectangleBorder(),
            elevation: 0,
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 30,
              color: result < 35
                  ? Colors.green
                  : (result < 45 ? Colors.amber : Colors.red),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        home: Result());
  }
}

class ResultState extends State<Result> {
  bool isStraight = false;

  // double insideR=rate;

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });

    if (isStraight) {
      return Container(
        color: Color.fromRGBO(255, 245, 227, 1),
        child: Column(children: [
          Row(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeMenuPage()));
                },
                child: Image.asset("images/home.png"),
                heroTag: "home",
              ),
              FloatingActionButton(
                onPressed: _launchURLCustomerService,
                child: Image.asset("images/customerService.png"),
                heroTag: "customerService",
              ),
            ],
          ),
          Stack(
            alignment: const Alignment(0.0, -0.1),
            children: [
              Image.asset("images/rateBox.png"),
              Text(
                rate,
                style: new TextStyle(
                  fontSize: 50,
                  decoration: TextDecoration.none,
                  color: Color.fromRGBO(153, 87, 37, 1),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: []),
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
                    content,
                    style: TextStyle(
                      fontSize: 30,
                      color: result < 35
                          ? Colors.green
                          : (result < 45 ? Colors.amber : Colors.red),
                      decoration: TextDecoration.none,
                    ),

                    // rate < 35
                    //     ? "合格"
                    //     : rate < 45
                    //         ? ""
                    //         : "銷毀或\n將樣品送衛生局複檢",
                    // style: new TextStyle(fontSize: 45),
                  )
                ],
              ),
            ],
          ),
        ]),
      );
    } else {
      return Container(
        color: Color.fromRGBO(255, 245, 227, 1),
        child: Column(

            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              ),
              Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeMenuPage()));
                    },
                    child: Image.asset("images/home.png"),
                    heroTag: "home",
                  ),
                  FloatingActionButton(
                    onPressed: _launchURLCustomerService,
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
                              rate,
                              style: new TextStyle(
                                fontSize: 50,
                                decoration: TextDecoration.none,
                                color: Color.fromRGBO(153, 87, 37, 1),
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
                        content,
                        style: TextStyle(
                          fontSize: 30,
                          color: result < 35
                              ? Colors.green
                              : (result < 45 ? Colors.amber : Colors.red),
                          decoration: TextDecoration.none,
                        ),
                        // (rate<35
                        //     ? "合格"
                        //     :(rate<45
                        //         ? "通知供應單位延期採收\n追蹤農民用藥"
                        //         : "銷毀或\n將樣品送衛生局複檢")),
                        // style: new TextStyle(fontSize: 45),
                      )
                    ],
                  ),
                ],
              ),
            ]),
      );
    }
  }
}

// ignore: must_be_immutable

class Result extends StatefulWidget {
  @override
  ResultState createState() {
    return ResultState();
  }
}

_launchURLCustomerService() async {
  const url = 'http://www.labinhand.com.tw/connection.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
