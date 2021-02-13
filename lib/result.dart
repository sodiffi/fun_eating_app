// import 'dart:html';
import 'package:flutter/rendering.dart';
import 'dataBean.dart';
import 'customeItem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:csv/csv.dart';
import 'dart:io';

// import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ftpclient/ftpclient.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'sqlLite.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_share/flutter_share.dart';

import 'package:permission_handler/permission_handler.dart';

String rate = "0%";
String content = "合格";
double result;

class ResultPage extends StatelessWidget {
  final String ftpHost="ftp.byethost12.com";
  // final String ftpHost="120.106.210.250";
  final String ftpName="b12_27143036";
  // final String ftpName="admin";
  final String ftpPsw="xkpt3v";
  // final String ftpPsw="wj/61j4zj6gk4";
  // final String changeDir="Public/PesticsdeTest_upload/";
  final String changeDir="htdocs/fun_heart_eating/";
  DataBean dataBean = new DataBean();

  ResultPage(DataBean d) {
    dataBean = d;
    rate = dataBean.result.floor().toString() + "%";
    result = dataBean.result;

    getCsv();
    if (dataBean.result <= 35)
      content = "合格";
    else if (dataBean.result <= 45)
      content = "通知供應單位延期採收\n追蹤農民用藥";
    else
      content = "銷毀或\n將樣品送衛生局複檢";
  }

  getCsv() async {
    print("enter get csv");

    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

//------------------------
    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < dataBean.beforeL.length-1; i++) {
      List<dynamic> row = List();
      row.add(i);
      row.addAll(dataBean.beforeL[i]);
      rows.add(row);
    }
    rows.add(["----", "----", "----", "----"]);
    for (int i = 0; i < dataBean.afterL.length-1; i++) {
      List<dynamic> row = List();
      row.add(i);
      row.addAll(dataBean.afterL[i]);

      rows.add(row);
    }
    rows.add(["----", "----", "----", "----"]);
    rows.add(["rate", result]);

    //------------------------
    if (await Permission.storage.request().isGranted) {
      String platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      Directory tempDir = await getApplicationDocumentsDirectory();
      String dir = tempDir.path + "/";
      // String dir = (await getExternalStorageDirectory()).absolute.path + "/";
      print(dir);
      print("platformIemi\t" + platformImei);

      // file = "$dir";
      new File(dir + dataBean.time + ".csv")
          .create(recursive: true)
          .then((f) async {
        // convert rows to String and write as csv file

        String csv = const ListToCsvConverter().convert(rows);
        await f.writeAsString(csv);
        FTPClient ftpClient = FTPClient(ftpHost,
            user: ftpName, pass: ftpPsw);
        ftpClient.connect();
        ftpClient.changeDirectory(changeDir);
        ftpClient.makeDirectory(platformImei);
        ftpClient.changeDirectory(platformImei);
        await ftpClient.uploadFile(f);
        ftpClient.disconnect();
      });

      FunHeartProvider fProvider = new FunHeartProvider();
      await fProvider.open();
      print(dataBean.area);
      await fProvider.insert(new FunHeart(dataBean.time, dataBean.fruitClass,
          dataBean.fruitName, dataBean.area, dataBean.result.floor()));
    }
//     await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
//     bool checkPermission = await SimplePermissions.checkPermission(
//         Permission.WriteExternalStorage);
//     if (checkPermission) {
// //store file in documents folder
//
//     }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ItemTheme.themeData,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Result(),
        ));
  }
}

// ignore: must_be_immutable

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
      reportBoxH = isStraight ? sizeHeight * 0.4 : sizeHeight * 0.7;
    });

    List<Widget> homeButton = [
      Padding(
        padding: EdgeInsets.all(5),
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
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: _launchURLCustomerService,
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
          height: reportBoxH,
          fit: BoxFit.fill,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(reportBoxW * 0.1, reportBoxH * 0.1,
              reportBoxW * 0.1, reportBoxH * 0.1),
          width: reportBoxW,
          height: reportBoxH,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: reportBoxW * 0.8 - iconSize,
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
                width: reportBoxW * 0.8 - iconSize,
                height: iconSize,
                child: AutoSizeText(
                  "農試所判定標準",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 100,
                    color: Color.fromRGBO(177, 48, 5, 1),
                  ),
                ),
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
              )
            ],
          ),
        )
      ],
    );

    if (isStraight) {
      return Container(
        color: Theme.of(context).backgroundColor,
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
                    children: <Widget>[report],
                  ),
                ]),
          ),
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(5),
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
                    )
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

_launchURLCustomerService() async {
  const url = 'http://www.labinhand.com.tw/connection.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
