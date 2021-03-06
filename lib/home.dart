import 'package:flutter/material.dart';
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
  int testTime = 0;
  bool isStraight = false;

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    main();
    double sizeHeight = isStraight
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    Widget homeButton = Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 0, 25),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeMenuPage()));
              },
              child: Image.asset(
                'images/setting.png',
                height: isStraight ? 50 : sizeHeight * 0.03,
                width: isStraight ? 50 : sizeHeight * 0.03,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 25),
            child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: _launchURLCustomerService,
              child: Image.asset(
                'images/customerService.png',
                height: isStraight ? 50 : sizeHeight * 0.03,
                width: isStraight ? 50 : sizeHeight * 0.03,
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
          width: sizeHeight*0.3,
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
                    width: sizeHeight * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Text("???????????????"),
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
                    width: sizeHeight * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Text("????????????")
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
                      width: sizeHeight * 0.3,
                      fit: BoxFit.cover,
                    ),
                    Text("????????????"),
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
                    width: sizeHeight * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "????????????",
                  )
                ],
              ),
            ),
          )
        ],
      )
    ];
    List<Widget> txtAndTestBtn = [
      Padding(padding: EdgeInsets.all(10)),
      Text(
        "FUN??????????????????",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Text(
        "??????${testTime}???",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      Padding(
        padding: EdgeInsets.all(15),
        child: FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (content) => CameraApp(0, cameras)));
          },
          padding: EdgeInsets.zero,
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                "images/testBox.png",
                width: sizeHeight * 0.45,
                fit: BoxFit.cover,
              ),
              Text(
                "????????????",
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
        ),
      )
    ];

    //????????????
    if (isStraight) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: <Widget>[
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
        ]),
      );
    } else {
      //????????????
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
