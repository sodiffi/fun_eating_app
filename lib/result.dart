// import 'dart:html';

// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csv/csv.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ftpclient/ftpclient.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'home.dart';
import 'sqlLite.dart';

String rate = "0%";
String content = "合格";
double result;

class ResultPage extends StatelessWidget {
  final String ftpHost = "120.106.210.250";
  final String ftpName = "admin";
  final String ftpPsw = "wj/61j4zj6gk4";
  final String changeDir = "Public/PesticsdeTest_upload/";
  // final String ftpHost = "ftp.byethost12.com";
  // final String ftpName = "b12_27143036";
  // final String ftpPsw = "xkpt3v";
  // final String changeDir = "htdocs/fun_heart_eating/";

  final DataBean dataBean;

  ResultPage({Key key, this.dataBean}) {
    rate = dataBean.result.floor().toString() + "%";
    result = dataBean.result;
    getCsv();
    if (dataBean.result <= 35)
      content = "合格";
    else if (dataBean.result <= 45)
      content = "通知供應單位延期採收追蹤農民用藥";
    else
      content = "銷毀或將樣品送衛生局複檢";
  }

  getCsv() async {
    print("enter get csv");

    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

//------------------------
    List<List<dynamic>> rows = List<List<dynamic>>.empty(growable: true);
    rows.add(["\uFEFF"]);
    for (int i = 0; i < dataBean.beforeL.length; i++) {
      List<dynamic> row = List.empty(growable: true);
      if (i < 180) {
        row.add(i);
        row.addAll(dataBean.beforeL[i]);
        rows.add(row);
      }
    }
    rows.add(["----", "----", "----", "----"]);
    for (int i = 0; i < dataBean.afterL.length; i++) {
      List<dynamic> row = List.empty(growable: true);
      if (i < 180) {
        row.add(i);
        row.addAll(dataBean.afterL[i]);
        rows.add(row);
      }
    }
    rows.add(["----", "----", "----", "----"]);
    rows.add(["rate", result]);
    rows.add(["蔬菜種類", dataBean.fruitClass]);
    rows.add(["購買地點", dataBean.area]);
    if (dataBean.fruitName != "") {
      rows.add(["蔬菜名稱", dataBean.fruitName]);
    }

    //------------------------
    if (await Permission.storage.request().isGranted) {
      String platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      // Directory tempDir = await getApplicationDocumentsDirectory();
      // String dir = tempDir.path + "/";
      String dir = (await getExternalStorageDirectory()).absolute.path + "/";
      print(dir);
      print("platformIemi\t" + platformImei);

      // file = "$dir";
      new File(dir + dataBean.time + "__" + platformImei + ".csv")
          .create(recursive: true)
          .then((f) async {
        // convert rows to String and write as csv file

        String csv = const ListToCsvConverter().convert(rows);
        await f.writeAsString(csv, encoding: utf8);
        FTPClient ftpClient = FTPClient(ftpHost, user: ftpName, pass: ftpPsw);
        ftpClient.connect();
        ftpClient.changeDirectory(changeDir);
        ftpClient.makeDirectory(platformImei);
        ftpClient.changeDirectory(platformImei);
        await ftpClient.uploadFile(f);
        ftpClient.disconnect();
      }).catchError((onError) => {print(onError)});

      FunHeartProvider fProvider = new FunHeartProvider();
      await fProvider.open();
      print(dataBean.area);
      await fProvider.insert(new FunHeart(dataBean.time, dataBean.fruitClass,
          dataBean.fruitName, dataBean.area, dataBean.result.floor()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ItemTheme.themeData,
        home: Scaffold(
          // resizeToAvoidBottomPadding: false,
          body: Result(),
        ));
  }
}

class Result extends StatefulWidget {
  @override
  ResultState createState() {
    return ResultState();
  }
}

class ResultState extends State<Result> {
  bool isStraight = false;
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  double reportBoxW;
  double reportBoxH;

  Future<void> share() async {
    await FlutterShare.share(
      title: '蔬果農藥檢測',
      text: '蔬果抑制率為:' + rate,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
      reportBoxW = isStraight ? sizeWidth * 0.8 : sizeWidth * 0.3;
      reportBoxH =
          isStraight ? (sizeHeight - 20 - (iconSize * 2)) : sizeHeight * 0.7;
    });

    List<Widget> homeButton = [
      Padding(
        padding:
            EdgeInsets.fromLTRB(isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeMenuPage()));
          },
          child: Image.asset(
            'images/home.png',
            height: iconSize,
            width: iconSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Padding(
        padding:
            EdgeInsets.fromLTRB(isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
        child: GestureDetector(
          onTap: () {
            LaunchUrl.connection();
          },
          child: Image.asset(
            'images/customerService.png',
            height: iconSize,
            width: iconSize,
            fit: BoxFit.cover,
          ),
        ),
      )
    ];

    Widget report = Stack(
      alignment: const Alignment(0.0, 0.0),
      children: [
        Image.asset(
          "images/report.png",
          width: reportBoxW,
          height: reportBoxH * 0.45,
          fit: BoxFit.fill,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(reportBoxW * 0.05, reportBoxH * 0.05,
              reportBoxW * 0.05, reportBoxH * 0.05),
          width: reportBoxW,
          height: reportBoxH * 0.45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: reportBoxW * 0.9 - iconSize,
                    height: iconSize,
                    child: Center(
                      child: AutoSizeText(
                        "檢測報告",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 100,
                          color: Color.fromRGBO(177, 48, 5, 1),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: share,
                    child: Image.asset(
                      'images/share.png',
                      height: iconSize,
                      width: iconSize,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: reportBoxW * 0.8,
                // height: iconSize,
                child: AutoSizeText(
                  "農試所判定標準",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 120,
                    color: Color.fromRGBO(177, 48, 5, 1),
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                      child: SizedBox(
                width: reportBoxW * 0.8,
                // height: reportBoxW*0.8-iconSize,
                child: AutoSizeText(
                  content,
                  maxLines: result < 35 ? 1 : 2,
                  style: TextStyle(
                    fontSize: 120,
                    color: result < 35
                        ? Colors.green
                        : (result < 45 ? Colors.amber : Colors.red),
                    decoration: TextDecoration.none,
                  ),
                ),
              )))
            ],
          ),
        )
      ],
    );

    if (isStraight) {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Container(
            color: Color.fromRGBO(255, 245, 227, 1),
            width: sizeWidth,
            height: sizeHeight,
            padding: EdgeInsets.all(5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: homeButton,
                  ),
                  SizedBox(
                    width: reportBoxW * 0.8,
                    height: iconSize,
                    child: AutoSizeText(
                      "蔬果汁抑制率",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 150,
                        color: Color.fromRGBO(177, 48, 5, 1),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: const Alignment(-1, -1),
                    children: [
                      Image.asset(
                        "images/rateBox.png",
                        height: reportBoxH * 0.43,
                      ),
                      SizedBox(
                        height: reportBoxH * 0.43 * 145 / 216,
                        width: reportBoxH * 0.43 / 213 * 145,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                reportBoxH * 0.43 * 38 / 216,
                                reportBoxH * 0.43 * 40 / 216,
                                0,
                                0),
                            child: Center(
                              child: AutoSizeText(
                                rate,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 50,
                                  decoration: TextDecoration.none,
                                  color: Color.fromRGBO(153, 87, 37, 1),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[report],
                  ),
                ]),
          ),
        ),
      );
    } else {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(iconSize, 5, iconSize, 5),
            color: Color.fromRGBO(255, 245, 227, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: homeButton,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: reportBoxW * 0.95,
                      height: iconSize,
                      child: AutoSizeText(
                        "蔬果汁抑制率",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 150,
                          color: Color.fromRGBO(177, 48, 5, 1),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: const Alignment(0.0, -0.2),
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
                  ],
                ),
                report
              ],
            ),
          ),
        ),
      );
    }
  }
}
