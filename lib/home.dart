// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_app/input.dart';
import 'package:flutter_app/result.dart';
import 'package:flutter_app/test.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';

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
              subtitle1: TextStyle(fontSize: 35),
              button: TextStyle(
                fontSize: 20,
              ))),
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

    Widget homeButton = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 0, 25),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeMenuPage()));
              },
              child: Image.asset(
                'images/setting.png',
                height: MediaQuery.of(context).size.height * 0.03,
                width: MediaQuery.of(context).size.height * 0.03,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: _launchURLCustomerService,
              child: Image.asset(
                'images/customerService.png',
                height: MediaQuery.of(context).size.height * 0.03,
                width: MediaQuery.of(context).size.height * 0.03,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // FlatButton(
        //  onPressed: () {
        //    Navigator.push(context,
        //        MaterialPageRoute(builder: (context) => ResultPage(44)));
        //  },
        //  child: Text("123")),
        Spacer(flex: 3),
      ],
    );

    List<Widget> actionButton = [
      FloatingActionButton(
        onPressed: () {},
        child: Image.asset("images/setting.png"),
        heroTag: "setting",
      ),
      FloatingActionButton(
        onPressed: _launchURLCustomerService,
        child: Image.asset("images/customerService.png"),
        heroTag: "customerService",
      ),
      // FlatButton(
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => ResultPage(0.5)));
      //     },
      //     child: Text("輸入頁"))
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
                      width: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "農食小知識",
                    )
                  ],
                ),
              )),
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
                      width: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "檢測紀錄",
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
              child: FlatButton(
                padding: EdgeInsets.zero,
                onPressed: _launchURLMap,
                child: Stack(
                  alignment: const Alignment(-0.2, -0.2),
                  children: [
                    Image.asset(
                      "images/txtBox.png",
                      width: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "農食地圖",
                    )
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
                      width: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "放心店家",
                    )
                  ],
                ),
              ))
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      Padding(padding: EdgeInsets.all(10)),
      Text(
        "FUN心吃專家等級",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Text(
        "檢測${testTime}次",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      Padding(
          padding: EdgeInsets.all(15),
          child: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CameraApp(0, cameras)));
              },
              padding: EdgeInsets.zero,
              child: Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Image.asset(
                    "images/testBox.png",
                    width: MediaQuery.of(context).size.height * 0.5,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "開始檢測",
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              )))
    ];

    //直立畫面
    if (isStraight) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              homeButton,
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                      Image.asset(
                        "images/logo_h.png",
                        height: 50,
                      )
                    ] +
                    txtAndTestBtn +
                    linkButtons,
              ))
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: <Widget>[
              //     Row(
              //       children: actionButton,
              //     )
              //   ],
              // ),
            ]),
      );
    } else {
      //橫立畫面
      return Container(
        width: MediaQuery.of(context).size.height * 1,
        color: Theme.of(context).backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15,25,0,0),
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
                          width: MediaQuery.of(context).size.height * 0.3,
                        )
                      ] +
                      linkButtons,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
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

Future<void> main() async {
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
