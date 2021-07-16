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
  MediaData mediaData = new MediaData();
  DataBean dataBean = new DataBean();
  double linkSize;
  //建立sql lite provider
  FunHeartProvider fProvider = new FunHeartProvider();
  //建構式取得相機資訊
  HomeState() {
    getCameras();
  }

  //去測驗畫面(階段一:裝置性穩定)
  Future<void> toTest() async {
    if (await Permission.camera.request().isGranted) {
      //設定步驟為0
      dataBean.step = 0;
      //設定相機資訊
      dataBean.cameras = cameras;
      //換頁
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => CameraApp(dataBean: dataBean)));
    }
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
      mediaData.update(context);
      linkSize = mediaData.isStraight
          ? min(mediaData.sizeHeight * 0.25, mediaData.sizeWidth * 0.4)
          : mediaData.sizeWidth * 0.17;
    });

    List<Widget> homeButton = [
      IconBtn(
        edgeInsets: mediaData.getPaddingFiveOrZero(),
        iconSize: mediaData.iconSize,
        imgStr: 'images/setting.png',
        onTap: () => Navigator.of(context).push(CupertinoPageRoute(
            builder: (BuildContext context) => SettingPage())),
      ),
      IconBtn(
        edgeInsets: mediaData.getPaddingFiveOrZero(),
        iconSize: mediaData.iconSize,
        imgStr: 'images/customerService.png',
        onTap: () => LaunchUrl.connection(),
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
            onTap: () => Navigator.of(context)
                .push(CupertinoPageRoute(builder: (content) => RecordPage())),
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
                width: 0.3 *
                    (mediaData.isStraight
                        ? mediaData.sizeHeight
                        : mediaData.sizeWidth),
                fit: BoxFit.cover,
              ),
              Container(
                width: 0.3 *
                    (mediaData.isStraight
                        ? mediaData.sizeHeight
                        : mediaData.sizeWidth),
                child: AutoSizeText(
                  "開始檢測",
                  maxLines: 1,
                  style: ItemTheme.textStyle,
                ),
                padding: EdgeInsets.all(0.036 *
                    (mediaData.isStraight
                        ? mediaData.sizeHeight
                        : mediaData.sizeWidth)),
              )
            ],
          ),
        ),
      )
    ];

    //直立畫面
    if (mediaData.isStraight) {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: homeButton),
                Image.asset(
                  "images/logo_h.png",
                  height: mediaData.sizeHeight * 0.1,
                ),
                Column(children: txtAndTestBtn),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Column(children: linkButtons),
                )
              ]),
        ),
      );
    } else {
      //橫立畫面
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                mediaData.iconSize, 5, mediaData.iconSize, 5),
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
                            width: mediaData.sizeHeight * 0.4,
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
