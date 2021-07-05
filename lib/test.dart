// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fun_heart_eat/home.dart';
import 'package:lamp/lamp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';
import 'package:manual_camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

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

  //啟用音效、震動
  final String isRingProp = "isRing";
  final String isShockProp = "isShock";
  bool isRing;
  bool isShock;
  List checkList = List.empty(growable: true);
  //測驗時間210
  int testTime = 5;
  //裝置穩定性檢查時間15
  int checkTime = 1;
  //在測驗時間中，不要讀取圖片的時間30
  int notGetImgTime = 3;
  //讀取圖片
  bool getImg = false;

  /*
  0-裝置位置及穩定性檢測
  1-第一階段檢測
  2-第二階段檢測
  */
  int step = 0;
  String min = "";
  String second = "";
  int passTime = 0;
  DataBean dataBean;
  Widget previewCamera = Container();
  Timer testTimer;
  Timer checkTimer;

  TestState(DataBean b) {
    dataBean = b;
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
      await controller.flash(false);
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
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
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

  /* 第一步驟 檢測光源*/
  Future<void> startCheck() async {
    //確認相機權限
    if (await Permission.camera.request().isGranted) {
      //打開相機
      await openCamera(dataBean.cameras[0]);
      //如果是ios，打開閃光燈
      if (Platform.isIOS) Lamp.turnOn();
      setState(() {
        previewCamera = _cameraPreviewWidget();
      });
      //每一秒做一次
      checkTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
        print("\t " + step.toString() + "\t" + checkList.length.toString());
        //檢測光源時間到時
        if (checkList.length == checkTime) {
          String msg = "";
          double sumr = 0, sumg = 0, sumb = 0;
          //加總r,g,b
          for (int i = 0; i < checkList.length; i++) {
            sumr += checkList[i][0];
            sumg += checkList[i][1];
            sumb += checkList[i][2];
          }
          //算rgb的平均值
          sumr /= checkList.length;
          sumg /= checkList.length;
          sumb /= checkList.length;

          //算CV 變異係數
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
          previewCamera = Container();
          await controller.stopImageStream();
          await controller.dispose();
          Navigator.pushReplacement(
            this.context,
            MaterialPageRoute(
              builder: (context) => TestMenuPage(
                dataBean: dataBean,
              ),
            ),
          );
        }
        getImg = true;
      });
    }
  }

  /* 第二、三步驟 測驗*/
  Future<void> startTest() async {
    int count;
    //開相機
    await openCamera(dataBean.cameras[0]);
    if (Platform.isIOS) Lamp.turnOn();
    testTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      passTime++;
      print("\t$step ${timer.tick} ");
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
        //是否啟用鈴聲
        if (isRing ?? true)
          FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: const IosSound(1023),
            looping: false,
            volume: 0.1,
          );

        //是否啟用震動
        if (isShock ?? true) Vibration.vibrate();

        testTimer.cancel();
        off();
        if (step == 1) {
          dataBean.beforeAvg = getData(dataBean.beforeL);
          //酵素棒似乎有問題，請更換酵素棒，再試一次
          if (dataBean.beforeAvg[2] < -0.03) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('注意'),
                content: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '此酵素或環境變化過大\n請檢查裝置\n請問您要',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(text: "放棄", style: TextStyle(color: Colors.red)),
                    TextSpan(text: "還是", style: TextStyle(color: Colors.black)),
                    TextSpan(text: "繼續", style: TextStyle(color: Colors.red)),
                  ]),
                ),
                actions: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(false);
                      Navigator.pushReplacement(
                        this.context,
                        MaterialPageRoute(
                          builder: (context) => AddFruit(dataBean: dataBean),
                        ),
                      );
                    },
                    child: Text("繼續"),
                  ),
                  SizedBox(height: 16),
                  new GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(false);
                      Navigator.pushReplacement(
                        this.context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text("放棄"),
                  ),
                ],
              ),
            );
          }
        } else {
          dataBean.afterAvg = getData(dataBean.afterL);
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
            this.context,
            MaterialPageRoute(
              builder: (context) => ResultPage(dataBean: dataBean),
            ),
          );
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
      return SafeArea(
        child: Expanded(
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
                            color: Color.fromRGBO(248, 203, 173, 1), width: 5),
                        color: Color.fromRGBO(255, 242, 204, 1),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(15),
                      ),
                      child: Text(
                        "$min:$second",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(105, 57, 8, 1),
                            decoration: TextDecoration.none),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized)
      return Container();
    else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

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
          _showCameraException(e);
        }
      } else if (Platform.isIOS) {
        try {
          for (int i = 0; i < image.planes[0].bytes.length; i += 4) {
            b += image.planes[0].bytes[i].toDouble();
            g += image.planes[0].bytes[i + 1].toDouble();
            r += image.planes[0].bytes[i + 2].toDouble();
          }
        } catch (e) {
          _showCameraException(e);
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

  //打開相機
  Future<void> openCamera(CameraDescription cameraDescription) async {
    //如果controller不等於null(已經開過)
    if (controller != null) {
      previewCamera = Container();
      await controller.dispose();
    }
    try {
      controller = CameraController(
        cameraDescription,
        ResolutionPreset.medium,
        iso: 0,
        shutterSpeed: 0,
        whiteBalance: WhiteBalancePreset.cloudy,
        focusDistance: 0,
        enableAudio: false,
      );
      //初始化controller
      await controller.initialize().then((_) async {
        if (!mounted) return;
        await Future.delayed(Duration(milliseconds: 250));
      });
      await Future.delayed(Duration(milliseconds: 250));
      //開始圖片流並指定function 處理
      await controller.startImageStream((image) => getRGB(image));
    } catch (e) {
      print(e);
    }
    //開啟相機閃光燈
    await controller.flash(true).catchError((e) {
      print(e);
    });
    await Future.delayed(Duration(milliseconds: 250));

    //加入監聽器當有error會印出東西(開發用)
    controller.addListener(() {
      if (controller.value.hasError)
        logError('Camera error ${controller.value.errorDescription}');
    });

    // if(Platform.isIOS) Lamp.turnOn();
  }

  void _showCameraException(Exception e) {
    print("--------");
    print("camera exception");
    if (e is CameraException)
      logError(e.code + "\nError Message" + e.description);
    else
      logError(e.toString());
    print("--------");
    // showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

Future<void> logError(var msg) async {
  print('Error: ${msg.toString()}');
}
