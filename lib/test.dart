import 'dart:async';
import 'dart:io';
import 'package:flutter_app/addFruit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/result.dart';
import 'testMenu.dart';
import 'package:csv/csv.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras = [];
List beforeAvg;
List afterAvg;
List beforeL;

// int step;

class CameraHome extends StatefulWidget {
  int step = 0;

  CameraHome(int s) {
    step = s;
  }

  @override
  TestState createState() {
    return TestState(step);
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class TestState extends State<CameraHome> with WidgetsBindingObserver {
  CameraController controller;
  bool enableAudio = true;
  List checkList = new List();
  List beforeList = new List();
  List afterList = new List();
  //測驗時間210
  int testTime = 21;
  //裝置穩定性檢查時間15
  int checkTime = 3;
  //在測驗時間中，不要讀取圖片的時間30
  int notGetImgTime = 3;
  bool getImg = false;
  // bool firstStepEnd = false;
  int step = 0;
  BuildContext cc;
  String min = "";
  String second = "";

  //0-裝置位置及穩定性檢測
  //1-第一階段檢測
  //2-第二階段檢測
  TestState(int s) {
    step = s;
    if (s == 0) {
      startCheck();
      print("cameras length" + cameras.length.toString());
    } else {
      startTest();
    }
  }

  TestState.empty();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // controller.setFlashMode(FlashMode.off);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.setFlashMode(FlashMode.off);
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void startCheck() {
    onNewCameraSelected(cameras[0]);
    Fluttertoast.showToast(
        msg: "開始裝置及穩定性檢測",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick == checkTime) {
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
        controller.setFlashMode(FlashMode.off);
        controller.dispose();
        Navigator.pushReplacement(
            cc, MaterialPageRoute(builder: (context) => TestMenuPage()));
      }
      getImg = true;
    });
  }

  void startTest() {
    onNewCameraSelected(cameras[0]);
    Fluttertoast.showToast(
        msg: "開始測驗",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        min = ((timer.tick + (step == 2 ? 210 : 0)) / 60).floor().toString();
        second = ((timer.tick + (step == 2 ? 210 : 0)) % 60).floor().toString();
        if (second.length == 1) second = "0" + second;
      });
      print("${step} ${timer.tick}");
      if (timer.tick > notGetImgTime) {
        getImg = true;
      }
      if (timer.tick == testTime) {
        timer.cancel();
        controller.setFlashMode(FlashMode.off);
        if (step == 1) {
          print("before List"+beforeList.toString());
          beforeAvg = getData(beforeList);
          //酵素棒似乎有問題，請更換酵素棒，再試一次
          if (beforeAvg[2] > 0.008) {
            Fluttertoast.showToast(
                msg: "酵素棒似乎有問題，請更換酵素棒，再試一次",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }


          Navigator.push(cc,
              MaterialPageRoute(builder: (context) => AddFruit(beforeList)));
        } else {
          beforeAvg = getData(beforeL);
          afterAvg = getData(afterList);
          print("-------first finish-------");
          print(beforeL.length);
          print("-------");
          print(beforeAvg);
          print("-------");
          print(afterAvg);
          print("-------first finish-------");
          double rate = 1 -
              ((afterAvg[2] / beforeAvg[2]) *
                  (beforeAvg[0] / afterAvg[0]) *
                  (beforeAvg[1] / afterAvg[1]));
          print("1:${(afterAvg[2] / beforeAvg[2])}");
          print("2:${(beforeAvg[0] / afterAvg[0])}");
          print("3:${(beforeAvg[1] / afterAvg[1])}");
          print("rate ${rate}");
          print("beforeList ${beforeList.length}");
          print("afterList ${afterList.length}");
          Navigator.push(
              cc,
              MaterialPageRoute(
                  builder: (context) => ResultPage(rate.isNaN ? 0 : rate,beforeL,afterList)));
        }
      }
    });
  }

  List getData(List data) {
    List<double> rList = new List();
    List<double> gList = new List();
    List<double> bList = new List();
    List<double> result = [0, 0, 0];
    int countTime = 0;
    print("data"+data.toString());
    //計算斜率
    for (int i = 1; i < data.length; i++) {
      rList.add(data[i][0] - data[i - 1][0]);
      gList.add(data[i][1] - data[i - 1][1]);
      bList.add(data[i][2] - data[i - 1][2]);
      print("count "+(data[i][2] - data[i - 1][2]).toString());
    }
    //排序
    print(bList);
    bList.sort();
    //取中間25%~75%的資料
    for (int i = (bList.length * 0.25).floor();
        i < (bList.length * 0.75).floor();
        i++) {

      result[0] += rList[i];
      result[1] += gList[i];
      result[2] += bList[i];
      countTime++;
      print("result "+i.toString()+result.toString());
    }
    print("countTime"+countTime.toString());
    result[0] = result[0] / countTime;
    result[1] /= countTime;
    result[2] /= countTime;


    return result;
  }

  @override
  Widget build(BuildContext context) {
    cc = context;
    if (step == 0) {
      return Scaffold(
          key: _scaffoldKey,
          body: Center(child: Image.asset("images/signal.png")));
    } else {
      return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
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
                          "${min}:${second}",
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
      );
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Row();
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  // void showInSnackBar(String message) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  // }

  void convertYUV420toImageColor(CameraImage image) async {
    if (getImg) {
      if (Platform.isAndroid) {
        try {
          final int width = image.width;
          final int height = image.height;
          final int uvRowStride = image.planes[1].bytesPerRow;
          final int uvPixelStride = image.planes[1].bytesPerPixel;
          double r = 0;
          double g = 0;
          double b = 0;

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
          if (step == 0) {
            checkList.add([r, g, b]);
          } else if (step == 1) {
            beforeList.add([r, g, b]);
          } else {
            afterList.add([r, g, b]);
          }
          print("\t${r}\t${g}\t${b}");
          getImg = false;
        } catch (e) {
          print(">>>>>>>>>>>> ERROR:" + e.toString());
        }
      }
    }
  }

  getCsv(double rate, List afterL) async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < beforeL.length; i++) {
      List<dynamic> row = List();
      row.add(i);
      row.addAll(beforeL[i]);
      rows.add(row);
    }
    rows.add(["----", "----", "----", "----"]);
    for (int i = 0; i < afterL.length; i++) {
      List<dynamic> row = List();
      row.add(i);
      row.addAll(afterL[i]);
      rows.add(row);
    }
    rows.add(["----", "----", "----", "----"]);
    rows.add(["rate", rate]);

//     for (int i = 0; i < associateList.length; i++) {
// //row refer to each column of a row in csv file and rows refer to each row in a file
//       List<dynamic> row = List();
//       row.add(associateList[i].name);
//       row.add(associateList[i].gender);
//       row.add(associateList[i].age);
//       rows.add(row);
//     }

    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    bool checkPermission = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (checkPermission) {
//store file in documents folder

      String dir = (await getExternalStorageDirectory()).absolute.path +
          "/fun_heart_eating";
      // file = "$dir";
      File f = new File(dir + "filename.csv");

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
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
    controller.startImageStream((image) => {convertYUV420toImageColor(image)});
    await controller.setFlashMode(FlashMode.torch);
  }

  void _showCameraException(CameraException e) {
    print("--------");
    print("camera exception");
    logError(e.code, e.description);
    print("--------");
    // showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class CameraApp extends StatelessWidget {
  int step = 0;

  CameraApp(int s, List<CameraDescription> c) {
    step = s;
    cameras = c;
  }

  CameraApp.second(int s, List<CameraDescription> c, List b) {
    step = s;
    cameras = c;
    beforeL = b;
    print("from second ${b.first}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentTextTheme: TextTheme(body2: TextStyle(color: Colors.white)),
      ),
      home: CameraHome(step),
      debugShowCheckedModeBanner: false,
    );
  }
}
