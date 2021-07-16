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
import 'sqlLite.dart';

String rate = "0%";
String content = "合格";
double result;

class ResultPage extends StatelessWidget {
  // final String ftpHost = "120.106.210.250";
  // final String ftpName = "admin";
  // final String ftpPsw = "wj/61j4zj6gk4";
  // final String changeDir = "Public/PesticsdeTest_upload/";
  final String ftpHost = "ftp.epizy.com";
  final String ftpName = "epiz_29155890";
  final String ftpPsw = "GGdnkB1YsZC2c";
  final String changeDir = "htdocs/yemt/";

  final DataBean dataBean;

  ResultPage({Key key, this.dataBean}) {
    rate = dataBean.result.floor().toString() + "%";
    result = dataBean.result;
    getCsv();
    if (dataBean.result <= 35)
      content = "請安心享用~";
    else if (dataBean.result <= 45)
      content = "請再清洗一遍您的蔬果呦!";
    else
      content = "農藥殘留高風險!";
  }

  getCsv() async {
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
      String dir;
      String platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      if (Platform.isAndroid)
        dir = (await getExternalStorageDirectory()).absolute.path + "/";
      if (Platform.isIOS)
        dir = (await getApplicationDocumentsDirectory()).absolute.path + "/";
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
      }).catchError(logError);

      FunHeartProvider fProvider = new FunHeartProvider();
      await fProvider.open();
      await fProvider.insert(new FunHeart(dataBean.time, dataBean.fruitClass,
          dataBean.fruitName, dataBean.area, dataBean.result.floor()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ItemTheme.themeData,
      home: Scaffold(body: Result()),
    );
  }
}

class Result extends StatefulWidget {
  @override
  ResultState createState() {
    return ResultState();
  }
}

class ResultState extends State<Result> {
  MediaData mediaData = new MediaData();
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
      mediaData.update(context);
      reportBoxW = mediaData.isStraight
          ? mediaData.sizeWidth * 0.8
          : mediaData.sizeWidth * 0.3;
      reportBoxH = mediaData.isStraight
          ? (mediaData.sizeHeight - 20 - (mediaData.iconSize * 2))
          : mediaData.sizeHeight * 0.7;
    });

    List<Widget> homeButton = [
      IconBtn(
        edgeInsets: mediaData.getPaddingFiveOrZero(),
        iconSize: mediaData.iconSize,
        imgStr: 'images/home.png',
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop(context);
        },
      ),
      IconBtn(
        edgeInsets: mediaData.getPaddingFiveOrZero(),
        iconSize: mediaData.iconSize,
        imgStr: 'images/customerService.png',
        onTap: () => LaunchUrl.connection(),
      ),
    ];

    Widget report = Stack(
      alignment: const Alignment(0.0, 0.0),
      children: [
        Image.asset(
          "images/report.png",
          width: reportBoxW,
          height: reportBoxH * (mediaData.isStraight ? 0.45 : 1),
          fit: BoxFit.fill,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(reportBoxW * 0.05, reportBoxH * 0.05,
              reportBoxW * 0.05, reportBoxH * 0.05),
          width: reportBoxW,
          height: reportBoxH * (mediaData.isStraight ? 0.45 : 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: reportBoxW * 0.9 - mediaData.iconSize,
                    height: mediaData.iconSize,
                    child: Center(
                      child: AutoSizeText(
                        "檢測報告",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 100,
                          color: ItemTheme.redBrownColor,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: share,
                    child: Image.asset(
                      'images/share.png',
                      height: mediaData.iconSize,
                      width: mediaData.iconSize,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: reportBoxW * 0.8,
                    child: AutoSizeText(
                      content,
                      maxLines: result >= 35 && result < 45 ? 2 : 1,
                      style: TextStyle(
                        fontSize: 120,
                        color: result < 35
                            ? Colors.green
                            : (result < 45 ? Colors.amber : Colors.red),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: reportBoxW * 0.8,
                child: AutoSizeText(
                  "[測試結果可能因溫度、操作或試劑保存等而略有差異，測試結果僅供參考。]",
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 120,
                    color: ItemTheme.redBrownColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

    if (mediaData.isStraight) {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Container(
            color: ItemTheme.bgColor,
            width: mediaData.sizeWidth,
            height: mediaData.sizeHeight,
            padding: EdgeInsets.all(5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: homeButton,
                  ),
                  SizedBox(
                    width: reportBoxW * 0.8,
                    height: mediaData.iconSize,
                    child: AutoSizeText(
                      "蔬果汁抑制率",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 150,
                        color: ItemTheme.redBrownColor,
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
            padding: EdgeInsets.fromLTRB(
                mediaData.iconSize, 5, mediaData.iconSize, 5),
            color:ItemTheme.bgColor,
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
                      height: mediaData.iconSize,
                      child: AutoSizeText(
                        "蔬果汁抑制率",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 150,
                          color:ItemTheme.redBrownColor,
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
void logError(var mes) => print('Error: ${mes.toString()}');
