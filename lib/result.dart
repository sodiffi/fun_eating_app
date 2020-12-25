// import 'dart:html';
import 'package:flutter_app/screenArgs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';


String rate = "0%";
String content = "合格";
double result;
List before;
List after;

class ResultPage extends StatelessWidget {
  ResultPage(double r, List b, List a) {
    result = r;
    rate = result.floor().toString() + "%";
    before = b;
    after = a;
    print("enter result page");
    print(before.length);
    // getCsv();
    if (result <= 35)
      content = "合格";
    else if (result <= 45)
      content = "通知供應單位延期採收\n追蹤農民用藥";
    else
      content = "銷毀或\n將樣品送衛生局複檢";
  }

  @override
  Widget build(BuildContext context) {
    // final ScreenArgs args = ModalRoute.of(context).settings.arguments;
    // result = args.result;

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

  getCsv() async {
    print("enter get csv");
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

//------------------------
    List<List<dynamic>> rows = List<List<dynamic>>();
    print(before.length);
    for (int i = 0; i < before.length; i++) {
      List<dynamic> row = List();
      row.add(""+i.toString());
      row.addAll(before[i]);
      print(row);
      rows.add(row);
    }
    rows.add(["----", "----", "----", "----"]);
    for (int i = 0; i < (after.length>209?209:after.length); i++) {
      List<dynamic> row = List();
      row.add(i);
      row.addAll(after[i]);
      rows.add(row);
    }
    rows.add(["----", "----", "----", "----"]);
    rows.add(["rate", result]);
    //------------------------

//     for (int i = 0; i < associateList.length; i++) {
// //row refer to each column of a row in csv file and rows refer to each row in a file
//       List<dynamic> row = List();
//       row.add(associateList[i].name);
//       row.add(associateList[i].gender);
//       row.add(associateList[i].age);
//       rows.add(row);
//     }

    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    bool checkPermission = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (checkPermission) {
//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path +
          "/fun_heart_eating";
      print(dir);
      // file = "$dir";
      File f = new File(dir +DateTime.now().toString()+".csv");

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
    }

  }

  @override
  void initState() {
    super.initState();
    print(" result state initstate");
    getCsv();
  }

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
