import 'package:flutter/material.dart';
import 'package:flutter_app/dataBean.dart';
import 'package:flutter_app/sqlLite.dart';
import 'package:flutter_app/test.dart';
import 'package:flutter_app/itemTheme.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int testTime=0;
  bool isStraight = false;
  DataBean dataBean = new DataBean();

  void toTest() {
    dataBean.step = 0;
    dataBean.cameras = cameras;
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => CameraApp(dataBean)));
  }

  Future<void> getTestTime() async {
    FunHeartProvider fProvider = new FunHeartProvider();
    await fProvider.open();
    await fProvider.getFunHeart().then((value) => this.setState(() {
          testTime = (value.length) == null ? 0 : value.length;
        }));
    await fProvider.close();
  }

  @override
  Widget build(BuildContext context) {
    if (testTime == null) {
      getTestTime();
    }
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    getCameras();
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth=MediaQuery.of(context).size.width;
    Widget homeButton = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeMenuPage()));
              },
              child: Image.asset(
                'images/setting.png',
                height: isStraight ? sizeWidth/7 : sizeHeight * 0.03,
                width: isStraight ? sizeWidth/7 : sizeHeight * 0.03,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: _launchURLCustomerService,
              child: Image.asset(
                'images/customerService.png',
                height: isStraight ? 45 : sizeHeight * 0.03,
                width: isStraight ? 45 : sizeHeight * 0.03,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Spacer(flex: 3),
      ],
    );

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
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: _launchURLKnowledge,
              child: Stack(
                alignment: const Alignment(-0.3, -0.3),
                children: [
                  Image.asset(
                    "images/txtBox.png",
                    width: sizeHeight * 0.25,
                    fit: BoxFit.cover,
                  ),
                  Text("農食小知識"),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Stack(
                alignment: const Alignment(-0.2, -0.2),
                children: [
                  Image.asset(
                    "images/txtBox.png",
                    width: sizeHeight * 0.25,
                    fit: BoxFit.cover,
                  ),
                  Text("檢測紀錄")
                ],
              ),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: _launchURLMap,
                child: Stack(
                  alignment: const Alignment(-0.2, -0.2),
                  children: [
                    Image.asset(
                      "images/txtBox.png",
                      width: sizeHeight * 0.25,
                      fit: BoxFit.cover,
                    ),
                    Text("農食地圖"),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.all(5),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: _launchURLStore,
              child: Stack(
                alignment: const Alignment(-0.2, -0.2),
                children: [
                  Image.asset(
                    "images/txtBox.png",
                    width: sizeHeight * 0.25,
                    fit: BoxFit.cover,
                  ),
                  Text("放心店家")
                ],
              ),
            ),
          )
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      Padding(padding: EdgeInsets.all(5)),
      Text(
        "FUN心吃專家等級",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Text(
        "檢測${testTime}次",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          onPressed: toTest,
          padding: EdgeInsets.zero,
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                "images/testBox.png",
                width: sizeHeight * 0.3,
                fit: BoxFit.cover,
              ),

              Text(
                "開始檢測",
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
        ),
      )
    ];

    //直立畫面
    if (isStraight) {
      // return Column(
      //
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //
      //   ],
      // );

      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              homeButton,
              Image.asset(
                "images/logo_h.png",
                height: 35,
              ),
              Column(
                children: txtAndTestBtn,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child:Column(
                  children: linkButtons,
                ) ,
              )
              // Center(
              //     child: Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //         Image.asset(
              //           "images/logo_h.png",
              //           height: 50,
              //         )
              //       ] +
              //       txtAndTestBtn +
              //       linkButtons,
              // ))
            ]),
      );
    } else {
      //橫立畫面
      return Container(
        width: sizeHeight * 1,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 25, 0, 0),
              child: Column(
                children: actionButton,
              ),
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                        Image.asset(
                          "images/logo.png",
                          width: sizeHeight * 0.3,
                        )
                      ] +
                      linkButtons,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: txtAndTestBtn,
                  ),
                ),
              ],
            ),
            Container(),
            Container(),
          ],
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
