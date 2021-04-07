// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as imglib;
import 'package:lamp/lamp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

// Project imports:
import 'addFruit.dart';
import 'customeItem.dart';
import 'dataBean.dart';
import 'result.dart';
import 'testMenu.dart';

class CameraApp extends StatefulWidget {
  final DataBean dataBean;
  CameraApp({Key key, this.dataBean}) : super(key: key);

  @override
  TestState createState() {
    return TestState(dataBean);
  }
}

class TestState extends State<CameraApp> with WidgetsBindingObserver {
  CameraController controller;

  //啟用音效
  final String isRingProp = "isRing";
  final String isShockProp = "isShock";
  bool isRing;
  bool isShock;
  List checkList = List.empty(growable: true);
  //測驗時間210
  int testTime = 210;
  //裝置穩定性檢查時間15
  int checkTime = 15;
  //在測驗時間中，不要讀取圖片的時間30
  int notGetImgTime = 30;
  //讀取圖片
  bool getImg = false;

  /*
  0-裝置位置及穩定性檢測
  1-第一階段檢測
  2-第二階段檢測
  */
  int step = 0;
  BuildContext cc;
  String min = "";
  String second = "";
  int passTime = 0;
  DataBean dataBean = new DataBean();
  Widget previewCamera = Container();
  Timer testTimer;
  Timer checkTimer;

  TestState(DataBean d) {
    dataBean = d;
    step = dataBean.step;
    Wakelock.enable();
    if (dataBean.step == 0) {
      getSP();
      startCheck();
      Fluttertoast.showToast(
          msg: "!注意!請將盡頭對準量測盒內壁",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(64, 64, 64, 1),
          textColor: Colors.white,
          fontSize: 20.0);
    } else {
      if (dataBean.step == 1)
        dataBean.beforeL = List.empty(growable: true);
      else
        dataBean.afterL = List.empty(growable: true);
      startTest();
    }
  }

  Future<void> getSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isRing = (prefs.getBool(isRingProp) ?? true);
    isShock = (prefs.getBool(isShockProp) ?? true);
  }

  Future<void> off() async {
    Wakelock.disable();
    if (Platform.isAndroid) {
      try {
        await controller.setFlashMode(FlashMode.off);
      } on FlutterError {
        print("enter flutter error");
      } catch (e) {
        print(e);
      }
    } else
      Lamp.turnOff();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
    // controller.setFlashMode(FlashMode.off);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.toString());
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      // controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (dataBean.step == 0) {
        checkTimer.cancel();
        startCheck();
      } else if (dataBean.step > 0) {
        testTimer.cancel();
        startTest();
      } else {
        testTimer.cancel();
      }
    } else if (state == AppLifecycleState.paused) {}
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /* 第一步驟 檢測光源*/
  Future<void> startCheck() async {
    await onNewCameraSelected(dataBean.cameras[0]);
    setState(() {
      previewCamera = _cameraPreviewWidget();
    });
    checkTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("\t " + step.toString() + "\t" + checkList.length.toString());
      if (checkList.length == checkTime) {
        String msg = "";
        double sumr = 0, sumg = 0, sumb = 0;
        for (int i = 0; i < checkList.length; i++) {
          sumr += checkList[i][0];
          sumg += checkList[i][1];
          sumb += checkList[i][2];
        }
        sumr /= checkList.length;
        sumg /= checkList.length;
        sumb /= checkList.length;
        double cvr = 0, cvg = 0, cvb = 0, sr = 0, sg = 0, sb = 0;
        for (int i = 0; i < checkList.length; i++) {
          sr += checkList[i][0] - sumr;
          sg += checkList[i][1] - sumg;
          sb += checkList[i][2] - sumb;
        }
        cvr = sr / sumr;
        cvg = sg / sumg;
        cvb = sb / sumb;
        // 2. If (0.7*B avg< R avg) OR (0.7*B avg <G avg) Then

        if (0.7 * sumb < sumr || 0.7 * sumb < sumg) {
          msg = "主光訊號偏低，請檢查量測盒是否對準鏡頭及閃光燈";
        }
        //If if (R cv + G cv +B cv>chk Then
        if (cvr + cvg + cvb > 0.6) {
          msg = "光訊號不穩，請檢查量測盒黏貼情況";
        }
        if (msg != "") {
          Fluttertoast.showToast(
              msg: msg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        timer.cancel();

        off();
        controller.dispose();
        Navigator.pushReplacement(
            cc, MaterialPageRoute(builder: (context) => TestMenuPage()));
      }
      getImg = true;
    });
  }

  /* 第二、三步驟 測驗*/
  void startTest() {
    //開相機
    onNewCameraSelected(dataBean.cameras[0]);
    int count;

    testTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      passTime++;
      print("\t$step $timer.tick ");
      if (step == 1) {
        if (dataBean.beforeL.length <= testTime - notGetImgTime &&
            passTime > notGetImgTime) {
          count = dataBean.beforeL.length;
          getImg = true;
        }
      } else {
        if (dataBean.afterL.length <= testTime - notGetImgTime &&
            passTime > notGetImgTime) {
          count = dataBean.afterL.length;
          getImg = true;
        }
      }
      setState(() {
        min = ((passTime + (step == 2 ? 210 : 0)) / 60).floor().toString();
        second = ((passTime + (step == 2 ? 210 : 0)) % 60).floor().toString();
        if (second.length == 1) second = "0" + second;
      });
      if (count == testTime - notGetImgTime) {
        if (isRing ?? true) {
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: const IosSound(1023),
            looping: false,
            volume: 0.1,
          );
        }
        if (isShock ?? true) {
          Vibration.vibrate();
        }
        testTimer.cancel();
        off();
        if (step == 1) {
          print("\tbefore List" + dataBean.beforeL.toString());
          dataBean.beforeAvg = getData(dataBean.beforeL);
          //酵素棒似乎有問題，請更換酵素棒，再試一次
          if (dataBean.beforeAvg[2] > 0.008) {
            Fluttertoast.showToast(
                msg: "酵素棒似乎有問題，請更換酵素棒，再試一次",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          Navigator.pushReplacement(
              cc,
              MaterialPageRoute(
                  builder: (context) => AddFruit(
                        dataBean: dataBean,
                      )));
        } else {
          dataBean.afterAvg = getData(dataBean.afterL);
          print("\t" + dataBean.beforeAvg.toString());
          print("\t" + dataBean.afterAvg.toString());
          dataBean.result = (1 -
                  ((dataBean.afterAvg[2] / dataBean.beforeAvg[2]) *
                      (dataBean.beforeAvg[0] / dataBean.afterAvg[0]) *
                      (dataBean.beforeAvg[1] / dataBean.afterAvg[1]))) *
              100;
          if (dataBean.result.isNaN) dataBean.result = 0;
          if (dataBean.result > 100) {
            dataBean.result = 100;
          } else if (dataBean.result < 0) {
            dataBean.result = 0;
          } else {
            dataBean.result = double.parse(dataBean.result.floor().toString());
          }
          dataBean.step = -1;

          Navigator.pushReplacement(
              cc,
              MaterialPageRoute(
                  builder: (context) => ResultPage(dataBean: dataBean)));
        }
      }
    });
  }

  List getData(List data) {
    List<double> rList = List.empty(growable: true);
    List<double> gList = List.empty(growable: true);
    List<double> bList = List.empty(growable: true);
    List<double> result = [0, 0, 0];
    int countTimeB = 0;
    int countTimeRG = 0;
    //計算斜率
    for (int i = 1; i < data.length; i++) {
      bList.add(data[i][2] - data[i - 1][2]);
    }
    for (int i = 0; i < data.length; i++) {
      gList.add(data[i][1]);
      rList.add(data[i][0]);
    }
    //排序
    bList.sort();
    rList.sort();
    gList.sort();
    //取中間25%~75%的資料
    for (int i = (bList.length * 0.25).floor();
        i < (bList.length * 0.75).floor();
        i++) {
      result[2] += bList[i];
      countTimeB++;
    }
    for (int i = (rList.length * 0.25).floor();
        i < (rList.length * 0.75).floor();
        i++) {
      result[0] += rList[i];
      result[1] += gList[i];
      countTimeRG++;
    }
    result[2] /= countTimeB;
    result[1] /= countTimeRG;
    result[0] /= countTimeRG;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    cc = context;
    if (step == 0) {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Image.asset("images/signal.png"),
                flex: 1,
              ),
              Expanded(
                child: Center(child: previewCamera),
                flex: 1,
              ),
              Expanded(
                child: Image.asset("images/signal.png"),
                flex: 1,
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                          child: Stack(
                        alignment: Alignment(0.9, 0.7),
                        children: [
                          Image.asset("images/seal.gif"),
                          Container(
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Color.fromRGBO(248, 203, 173, 1),
                                  width: 5),
                              color: Color.fromRGBO(255, 242, 204, 1),
                              shape: BoxShape.rectangle,
                              borderRadius: new BorderRadius.circular(15),
                            ),
                            child: Text(
                              "$min:$second",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(105, 57, 8, 1)),
                            ),
                            padding: EdgeInsets.all(5),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  int _hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  // void showInSnackBar(String message) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  // }

  void getRGB(CameraImage image) async {
    if (getImg) {
      double r = 0;
      double g = 0;
      double b = 0;
      if (Platform.isAndroid) {
        try {
          final int width = image.width;

          final int height = image.height;
          final int uvRowStride = image.planes[1].bytesPerRow;
          final int uvPixelStride = image.planes[1].bytesPerPixel;
          for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
              final int uvIndex = uvPixelStride * (x / 2).floor() +
                  uvRowStride * (y / 2).floor();
              final int index = y * width + x;
              final yp = image.planes[0].bytes[index];
              final up = image.planes[1].bytes[uvIndex];
              final vp = image.planes[2].bytes[uvIndex];
              // Calculate pixel color
              r += (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
              g += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
                  .round()
                  .clamp(0, 255);
              b += (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
            }
          }
          int len = width * height;
          r /= len;
          g /= len;
          b /= len;
          print("------");
        } catch (e) {
          print(">>>>>>>>>>>> ANDROID ERROR:" + e.toString());
        }
      } else if (Platform.isIOS) {
        try {
          for (int i = 0; i < image.planes[0].bytes.length; i += 4) {
            b += image.planes[0].bytes[i].toDouble();
            g += image.planes[0].bytes[i + 1].toDouble();
            r += image.planes[0].bytes[i + 2].toDouble();
          }
        } catch (e) {
          print(">>>>>>>>>>>> IOS ERROR:" + e.toString());
        }
      }
      if (step == 0) {
        checkList.add([r, g, b]);
      } else if (step == 1) {
        dataBean.beforeL.add([r, g, b]);
      } else {
        dataBean.afterL.add([r, g, b]);
      }
      print("\there is rgb 原版: \t$r \t $g\t $b");

      getImg = false;
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      // if (mounted) setState(() {});
      if (controller.value.hasError) {
        // showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    controller.startImageStream((image) => {getRGB(image)});

    await controller.setFlashMode(FlashMode.torch);
    // if(Platform.isIOS) Lamp.turnOn();
  }

  void _showCameraException(CameraException e) {
    print("--------");
    print("camera exception");
    logError(e.code, e.description);
    print("--------");
    // showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
