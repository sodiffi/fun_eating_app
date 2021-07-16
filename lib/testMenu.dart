// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';
import 'package:manual_camera/camera.dart';

// Project imports:
import 'check.dart';
import 'customeItem.dart';
import 'dataBean.dart';
import 'input.dart';
import 'train.dart';

class TestMenuPage extends StatefulWidget {
  final DataBean dataBean;

  const TestMenuPage({Key key, this.dataBean}) : super(key: key);
  @override
  _TestMenuPageState createState() => _TestMenuPageState();
}

class _TestMenuPageState extends State<TestMenuPage> {
  MediaData mediaData = new MediaData();
  double imgW = 0;

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) {
      getCameras();
    }
    this.setState(() {
      mediaData.update(context);
      imgW = 0.3 *
          (mediaData.isStraight ? mediaData.sizeHeight : mediaData.sizeWidth);
    });

    Widget buttonTrainBox = Container(
      padding: EdgeInsets.all(10),
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
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => TrainPage())),
      ),
    );
    Widget buttonTestBox = Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TestInputPage())),
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
    );

    return Container(
      color: ItemTheme.bgColor,
      child: SafeArea(
        child: Container(
          padding: mediaData.getPaddingIconSizeOrFive(),
          color: ItemTheme.bgColor,
          child: SizedBox(
            child: Column(
              children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconBtn(
                          edgeInsets: EdgeInsets.fromLTRB(
                              mediaData.isStraight ? 5 : 0,
                              5,
                              mediaData.isStraight ? 5 : 5,
                              5),
                          onTap: () => Navigator.pop(context),
                          iconSize: mediaData.iconSize,
                          imgStr: 'images/home.png',
                        ),
                        CustomButton("檢測鏡頭", () {
                          DataBean d = new DataBean();
                          d.cameras = cameras;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckPage(dataBean: d),
                            ),
                          );
                        }),
                      ],
                    )
                  ] +
                  (mediaData.isStraight
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
      logError(e.code + "\nError Message" + e.description);
    }
  }
}
