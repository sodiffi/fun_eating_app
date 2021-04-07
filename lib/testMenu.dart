// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_better_camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'check.dart';
import 'customeItem.dart';
import 'dataBean.dart';
import 'home.dart';
import 'input.dart';
import 'train.dart';

class TestMenuPage extends StatefulWidget {
  @override
  _TestMenuPageState createState() => _TestMenuPageState();
}

class _TestMenuPageState extends State<TestMenuPage> {
  bool isStraight = false;
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  double imgW = 0;

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) {
      getCameras();
    }
    this.setState(() {
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
      imgW = isStraight ? sizeHeight * 0.3 : sizeWidth * 0.3;
    });

    Widget buttonTrainBox = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/trainBox.png',
                width: imgW,
                height: imgW,
                fit: BoxFit.cover,
              ),
              AutoTextChange(
                w: imgW,
                s: "操作教學",
                paddingW: imgW * 0.14,
                paddingH: imgW * 0.14,
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TrainPage()));
          },
        ),
      ),
    );
    Widget buttonTestBox = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TestInputPage()));
          },
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                'images/testBox.png',
                width: imgW,
                height: imgW,
                fit: BoxFit.cover,
              ),
              AutoTextChange(
                w: imgW,
                s: "開始檢測",
                paddingW: imgW * 0.14,
                paddingH: imgW * 0.14,
              )
            ],
          ),
        ),
      ),
    );

    return Container(
      color: ItemTheme.bgColor,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              isStraight ? 5 : iconSize, 5, isStraight ? 5 : iconSize, 5),
          color: ItemTheme.bgColor,
          child: SizedBox(
            child: Column(
              children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              isStraight ? 5 : 0, 5, isStraight ? 5 : 5, 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeMenuPage()));
                            },
                            child: Image.asset(
                              'images/home.png',
                              height: iconSize,
                              width: iconSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        CustomButton("檢測鏡頭", () {
                          DataBean d = new DataBean();
                          d.cameras = cameras;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckPage(
                                        dataBean: d,
                                      )));
                        }),
                      ],
                    )
                  ] +
                  (isStraight
                      ? [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Spacer(flex: 1),
                                Expanded(
                                  flex: 9,
                                  child: Column(
                                    children: [
                                      buttonTrainBox,
                                      buttonTestBox,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      : [
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.01),
                                  child: buttonTrainBox),
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.01),
                                  child: buttonTestBox)
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ]),
            ),
          ),
        ),
      ),
    );
  }
}

List<CameraDescription> cameras = [];

Future<void> getCameras() async {
  if (await Permission.camera.request().isGranted) {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
  }

  // Fetch the available cameras before initializing the app.
}
