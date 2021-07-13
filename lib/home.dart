// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:manual_camera/camera.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'record.dart';
import 'setting.dart';
import 'sqlLite.dart';
import 'test.dart';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  //預設測驗次數為0
  int testTime = 0;
  //預設手機方向直向
  bool isStraight = false;
  DataBean dataBean = new DataBean();
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  double linkSize;
  //建立sql lite provider
  FunHeartProvider fProvider = new FunHeartProvider();
  //建構式取得相機資訊
  HomeState() {
    getCameras();
  }

  //去測驗畫面(階段一:裝置性穩定)
  void toTest() {
    //設定步驟為0
    dataBean.step = 0;
    //設定相機資訊
    dataBean.cameras = cameras;
    //換頁
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => CameraApp(dataBean: dataBean)));
  }

  //取得測驗次數
  Future<int> getTestTime() async {
    int result = -1;
    await fProvider.open();
    while (result == -1)
      await fProvider
          .getFunHeart()
          .then((value) => result = (value) == null ? -1 : value.length);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    AutoSizeGroup linkGroup = AutoSizeGroup();
    getTestTime().then((value) => this.setState(() {
          testTime = value;
        }));
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
      linkSize = isStraight
          ? min(sizeHeight * 0.25, sizeWidth * 0.4)
          : sizeWidth * 0.17;
    });

    List<Widget> homeButton = [
      IconBtn(
        edgeInsets:
            EdgeInsets.fromLTRB(isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
        iconSize: iconSize,
        imgStr: 'images/setting.png',
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => CupertinoSetting()));
        },
      ),
      IconBtn(
        edgeInsets:
            EdgeInsets.fromLTRB(isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
        iconSize: iconSize,
        imgStr: 'images/customerService.png',
        onTap: () {
          LaunchUrl.connection();
        },
      ),
    ];

    List<Widget> linkButtons = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinkBtn(
            linkSize: linkSize,
            autoSizeGroup: linkGroup,
            text: "農食小知識",
            onTap: () => LaunchUrl.knowledge(),
          ),
          LinkBtn(
            linkSize: linkSize,
            autoSizeGroup: linkGroup,
            text: "檢測紀錄",
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (content) => RecordPage())),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinkBtn(
            linkSize: linkSize,
            autoSizeGroup: linkGroup,
            text: "農食地圖",
            onTap: () => LaunchUrl.map(),
          ),
          LinkBtn(
            linkSize: linkSize,
            autoSizeGroup: linkGroup,
            text: "放心店家",
            onTap: () => LaunchUrl.shop(),
          ),
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      AutoSizeText(
        "FUN心吃專家等級\n檢測 $testTime 次",
        style: ItemTheme.textStyle,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: toTest,
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                "images/testBox.png",
                width: isStraight ? sizeHeight * 0.3 : sizeWidth * 0.3,
                fit: BoxFit.cover,
              ),
              Container(
                width: isStraight ? sizeHeight * 0.3 : sizeWidth * 0.3,
                child: AutoSizeText(
                  "開始檢測",
                  maxLines: 1,
                  style: ItemTheme.textStyle,
                ),
                padding: EdgeInsets.all(isStraight
                    ? sizeHeight * 0.3 * 0.12
                    : sizeWidth * 0.3 * 0.12),
              )
            ],
          ),
        ),
      )
    ];

    //直立畫面
    if (isStraight) {
      return WillPopScope(
        onWillPop: () {
          return showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('確定離開嗎?'),
                  content: new Text('是否離開FUN心吃'),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text("否"),
                    ),
                    SizedBox(height: 16),
                    new GestureDetector(
                        onTap: () async => await SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop'),
                        child: Text("是")),
                  ],
                ),
              ) ??
              false;
        },
        child: Container(
          color: ItemTheme.bgColor,
          child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: homeButton),
                  Image.asset(
                    "images/logo_h.png",
                    height: sizeHeight * 0.1,
                  ),
                  Column(children: txtAndTestBtn),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(children: linkButtons),
                  )
                ]),
          ),
        ),
      );
    } else {
      //橫立畫面
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(iconSize, 5, iconSize, 5),
            color: ItemTheme.bgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: homeButton),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          Image.asset(
                            "images/logo.png",
                            width: sizeHeight * 0.4,
                          )
                        ] +
                        linkButtons,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: txtAndTestBtn,
                    ),
                  ),
                ),
                Container(),
                Container(),
              ],
            ),
          ),
        ),
      );
    }
  }
}

List<CameraDescription> cameras = [];

Future<void> getCameras() async {
  if (await Permission.camera.request().isGranted) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code + "\nError Message" + e.description);
    }
  }
}
