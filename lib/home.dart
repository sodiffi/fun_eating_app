// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_app/test.dart';
import 'testMenu.dart';
import 'package:flutter_better_camera/camera.dart';

class HomeMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "openhuninn",
          backgroundColor: Color.fromRGBO(254, 246, 227, 1),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(254, 246, 227, 1),
            shape: RoundedRectangleBorder(),
            elevation: 0,
          ),
          textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 35),
              subtitle1: TextStyle(fontSize: 35))),
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
  int testTime = 5;
  bool isStraight = false;

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    main();

    List<Widget> actionButton = [
      FloatingActionButton(
        onPressed: () {},
        child: Image.asset("images/setting.png"),
        heroTag: "setting",
      ),
      FloatingActionButton(
        onPressed: () {},
        child: Image.asset("images/customerService.png"),
        heroTag: "customerService",
      ),
    ];

    List<Widget> linkButtons = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {},
            child: Stack(
              alignment: const Alignment(0, 0),
              children: [
                Image.asset(
                  "images/txtBox.png",
                  width: 80,
                ),
                Text(
                  "農食小知識",
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Stack(
              alignment: const Alignment(0, 0),
              children: [
                Image.asset(
                  "images/txtBox.png",
                  width: 80,
                ),
                Text(
                  "檢測紀錄",
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Stack(
              alignment: const Alignment(0, 0),
              children: [
                Image.asset(
                  "images/txtBox.png",
                  width: 80,
                ),
                Text(
                  "農食地圖",
                )
              ],
            ),
          )
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      Text(
        "FUN心吃專家等級",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Text(
        "檢測${testTime}次",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (content) => CameraApp(0, cameras)));
          },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                "images/testBox.png",
                width: 250,
              ),
              Text(
                "開始檢測",
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ))
    ];

    //直立畫面
    if (isStraight) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                          Row(
                            children: actionButton,
                          )
                        ] +
                        [
                          Image.asset(
                            "images/logo.png",
                            height: 80,
                          )
                        ],
                  ),
                ] +
                txtAndTestBtn +
                linkButtons),
      );
    } else {
      //橫立畫面
      return Container(
          color: Theme.of(context).backgroundColor,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Column(
              children: actionButton,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                    Image.asset(
                      "images/logo.png",
                      width: 150,
                    )
                  ] +
                  linkButtons,
            ),
            Column(
              children: txtAndTestBtn,
            )
          ]));
    }
  }
}

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
}
