import 'package:flutter/material.dart';
import 'package:flutter_app/dataBean.dart';
import 'package:flutter_app/record.dart';
import 'package:flutter_app/sqlLite.dart';
import 'package:flutter_app/test.dart';
import 'package:flutter_app/itemTheme.dart';
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
    });
    getCameras();
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    List<Widget> homeButton = [
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeMenuPage()));
        },
        child: Image.asset(
          'images/setting.png',
          height: isStraight ? sizeWidth / 7 : sizeHeight * 0.03,
          width: isStraight ? sizeWidth / 7 : sizeHeight * 0.03,
          fit: BoxFit.cover,
        ),
      ),
      GestureDetector(
        onTap: _launchURLCustomerService,
        child: Image.asset(
          'images/customerService.png',
          height: isStraight ? sizeWidth / 7 : sizeHeight * 0.03,
          width: isStraight ? sizeWidth / 7 : sizeHeight * 0.03,
          fit: BoxFit.cover,
        ),
      )
    ];

    List<Widget> actionButton = [
      FloatingActionButton(
        onPressed: () {},
        child: Image.asset(
          "images/setting.png",
          width: sizeHeight * 0.3,
        ),
        heroTag: "setting",
      ),
      FloatingActionButton(
        onPressed: _launchURLCustomerService,
        child: Image.asset("images/customerService.png"),
        heroTag: "customerService",
      ),
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
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                    AutoTextChange(w:  isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                    s: "農食小知識",paddingW: isStraight
                          ? sizeHeight * 0.25 * 0.14
                          : sizeWidth * 0.2 * 0.14,paddingH: isStraight
                        ? sizeHeight * 0.25 * 0.14
                        : sizeWidth * 0.2 * 0.14,),

                    // Container(
                    //   width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                    //   child: AutoSizeText(
                    //     "農食小知識",
                    //     maxLines: 1,
                    //     style: ItemTheme.textStyle,
                    //   ),
                    //   padding: EdgeInsets.all(isStraight
                    //       ? sizeHeight * 0.25 * 0.14
                    //       : sizeWidth * 0.2 * 0.14),
                    // )
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
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      child: AutoSizeText(
                        "檢測紀錄",
                        maxLines: 1,
                        style: ItemTheme.textStyle,
                      ),
                      padding: EdgeInsets.all(isStraight
                          ? sizeHeight * 0.25 * 0.14
                          : sizeWidth * 0.2 * 0.14),
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
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      child: AutoSizeText(
                        "農食地圖",
                        maxLines: 1,
                        style: ItemTheme.textStyle,
                      ),
                      padding: EdgeInsets.all(isStraight
                          ? sizeHeight * 0.25 * 0.14
                          : sizeWidth * 0.2 * 0.14),
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
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: isStraight ? sizeHeight * 0.25 : sizeWidth * 0.2,
                      child: AutoSizeText(
                        "放心店家",
                        maxLines: 1,
                        style: ItemTheme.textStyle,
                      ),
                      padding: EdgeInsets.all(isStraight
                          ? sizeHeight * 0.25 * 0.14
                          : sizeWidth * 0.2 * 0.14),
                    )
                  ],
                ),
              ))
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      // Padding(padding: EdgeInsets.all(2)),
      AutoSizeText("FUN心吃專家等級\n檢測${testTime}次",style: ItemTheme.textStyle,maxLines: 2,textAlign: TextAlign.center,),
      // AutoSizeText("",style: ItemTheme.textStyle,),
      // Text(
      //   ,
      //   style: Theme.of(context).textTheme.bodyText1,
      // ),
      // Text(
      //
      //   style: Theme.of(context).textTheme.bodyText2,
      // ),
      Padding(
        padding: EdgeInsets.all(10),
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
      return SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: homeButton,
                  ),
                ),
                Image.asset(
                  "images/logo_h.png",
                  height: sizeHeight * 0.1,
                ),
                Column(
                  children: txtAndTestBtn,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Column(
                    children: linkButtons,
                  ),
                )
              ]),
        ),
      );
    } else {
      //橫立畫面
      return SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: sizeHeight * 1,
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: actionButton,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                      Image.asset(
                        "images/logo.png",
                        width: sizeHeight * 0.35,
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
