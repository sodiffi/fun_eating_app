import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:fun_Heart_eat/customeItem.dart';

import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'testMenu.dart';
import 'dataBean.dart';
import 'package:wakelock/wakelock.dart';

// import 'package:lamp/lamp.dart';

class CheckPage extends StatelessWidget {
  DataBean dataBean = new DataBean();

  CheckPage(DataBean d) {
    dataBean = d;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ItemTheme.themeData,
      home: Check(dataBean),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Check extends StatefulWidget {
  DataBean dataBean = new DataBean();
  Check(DataBean d) {
    dataBean = d;
  }

  @override
  CheckState createState() {
    return CheckState(dataBean);
  }
}

class CheckState extends State<Check> with WidgetsBindingObserver {
  CameraController controller;

  /*
  0-裝置位置及穩定性檢測
  1-第一階段檢測
  2-第二階段檢測
  */

  BuildContext cc;

  DataBean dataBean = new DataBean();
  Widget previewCamera = Container();
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  bool isStraight = false;

  CheckState(DataBean d) {
    dataBean = d;
    Wakelock.enable();
    open();
    // if (dataBean.step == 0) {
    //   startCheck();
    //   Fluttertoast.showToast(
    //       msg: "!注意!請將盡頭對準量測盒內壁",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Color.fromRGBO(64, 64, 64, 1),
    //       textColor: Colors.white,
    //       fontSize: 20.0);
    // } else {
    //   if (dataBean.step == 1)
    //     dataBean.beforeL = new List();
    //   else
    //     dataBean.afterL = new List();
    //   startTest();
    // }
  }

  Future<void> off() async {
    Wakelock.disable();
    if (Platform.isAndroid) {
      // try {
      //   await controller.setFlashMode(FlashMode.off);
      // } on FlutterError {
      //   print("enter flutter error");
      // } catch (e) {
      //   print(e);
      // }
    }
    // else Lamp.turnOff();
  }

  Future<void> open() async {
    await onNewCameraSelected(dataBean.cameras[0]);
    setState(() {
      previewCamera = _cameraPreviewWidget();
    });
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
    print("\tenter second dispose");
    // controller.setFlashMode(FlashMode.off);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // off();
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => TestMenuPage()));

      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    } else if (state == AppLifecycleState.paused) {
      // startCheck();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    setState(() {
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });
    cc = context;

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestMenuPage()));
                    },
                    child: Image.asset(
                      'images/home.png',
                      height: iconSize,
                      width: iconSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
            Row(
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
            Row(
              children: [
                CustomButton("開始檢測", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestMenu(),
                    ),
                  );
                })
              ],
            )
            // Flex(
            //   direction: Axis.horizontal,
            //   children: [

            //   ],
            // )
          ],
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    print("-----------");
    print("camera preview widget");
    print(controller == null);
    print("-----------");
    if (controller == null || !controller.value.isInitialized) {
      print("enter if");
      return Text("fail");
    } else {
      print("enter else");
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  // void showInSnackBar(String message) {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  // }

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
