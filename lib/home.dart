import 'dart:math';

import 'package:flutter/material.dart';
import 'dataBean.dart';
import 'record.dart';
import 'sqlLite.dart';
import 'test.dart';
import 'customeItem.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ItemTheme.themeData,
      home: HomeMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeMenu extends StatefulWidget {
  @override
  HomeMenuState createState() {
    return HomeMenuState();
  }
}

class HomeMenuState extends State<HomeMenu> {
  int testTime = 0;
  bool isStraight = false;
  DataBean dataBean = new DataBean();
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  double linkSize;
  int temp;

  void toTest() {
    dataBean.step = 0;
    dataBean.cameras = cameras;
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => CameraApp(dataBean)));
  }

  Future<int> getTestTime() async {
    int result;
    FunHeartProvider fProvider = new FunHeartProvider();
    await fProvider.open();
    await fProvider
        .getFunHeart()
        .then((value) => result = (value) == null ? 0 : value.length);
    await fProvider.close();
    return result;
  }

  @override
  Widget build(BuildContext context) {
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
    getCameras();
    AutoSizeGroup linkGroup = AutoSizeGroup();
    AutoSizeGroup LargeGroup = AutoSizeGroup();
    List<Widget> homeButton = [
      Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeMenuPage()));
          },
          child: Image.asset(
            'images/setting.png',
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

    List<Widget> linkButtons = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: _launchURLKnowledge,
                child: Stack(
                  alignment: const Alignment(0, 0),
                  children: [
                    Image.asset(
                      "images/txtBox.png",
                      width: linkSize,
                      fit: BoxFit.cover,
                    ),
                    AutoTextChange.group(
                      w: linkSize,
                      s: "農食小知識",
                      paddingW: linkSize * 0.14,
                      paddingH: 0,
                      autoSizeGroup: linkGroup,
                    ),
                  ],
                ),
              )),
          Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => RecordPage()));
                },
                child: Stack(
                  alignment: const Alignment(0, 0),
                  children: [
                    Image.asset(
                      "images/txtBox.png",
                      width: linkSize,
                      fit: BoxFit.cover,
                    ),
                    AutoTextChange.group(
                      w: linkSize,
                      s: "檢測紀錄",
                      paddingW: linkSize * 0.14,
                      paddingH: 0,
                      autoSizeGroup: linkGroup,
                    )
                  ],
                ),
              )),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: _launchURLMap,
                child: Stack(
                  alignment: const Alignment(0, 0),
                  children: [
                    Image.asset(
                      "images/txtBox.png",
                      width: linkSize,
                      fit: BoxFit.cover,
                    ),
                    AutoTextChange.group(
                      w: linkSize,
                      s: "農食地圖",
                      paddingW: linkSize * 0.14,
                      paddingH: 0,
                      autoSizeGroup: linkGroup,
                    )
                  ],
                ),
              )),
          Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: _launchURLStore,
                child: Stack(
                  alignment: const Alignment(0, 0),
                  children: [
                    Image.asset(
                      "images/txtBox.png",
                      width: linkSize,
                      fit: BoxFit.cover,
                    ),
                    AutoTextChange.group(
                      w: linkSize,
                      s: "放心店家",
                      paddingW: linkSize * 0.14,
                      paddingH: 0,
                      autoSizeGroup: linkGroup,
                    )
                  ],
                ),
              ))
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      // Padding(padding: EdgeInsets.all(2)),
      AutoSizeText(
        "FUN心吃專家等級\n檢測${testTime}次",
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
      return Container(
        color:Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: homeButton,
                  ),
                  Image.asset(
                    "images/logo_h.png",
                    height: sizeHeight * 0.1,
                  ),
                  Column(
                    children: txtAndTestBtn,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Column(
                      children: linkButtons,
                    ),
                  )
                ]),
          ),
        ),
      );
    } else {
      //橫立畫面
      return Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(5),
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: homeButton,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                        Image.asset(
                          "images/logo.png",
                          width: sizeHeight * 0.4,
                        )
                      ] +
                      linkButtons,
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: txtAndTestBtn,
                  ),
                )),
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
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
}

_launchURLKnowledge() async {
  const url = 'http://www.labinhand.com.tw/new.html';
  // const url = 'https://www.google.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLStore() async {
  const url = 'http://www.labinhand.com.tw/FUNshop.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
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

_launchURLMap() async {
  const url = 'http://www.labinhand.com.tw/FUNmaps.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
