// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_better_camera/camera.dart';
import 'package:wakelock/wakelock.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'home.dart';
import 'testMenu.dart';

// import 'package:lamp/lamp.dart';

class CheckPage extends StatefulWidget {
  final DataBean dataBean;

  CheckPage({Key key, @required this.dataBean}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CheckState(dataBean);
  }
}

class CheckState extends State<CheckPage> with WidgetsBindingObserver {
  CameraController controller;
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
  }

  Future<void> off() async {
    Wakelock.disable();
    if (Platform.isAndroid) {
      // try {
      await controller.setFlashMode(FlashMode.off);
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
    off();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("check");
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => TestMenuPage()));
      off();
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (dataBean.step > 0) open();
    } else if (state == AppLifecycleState.paused) {
      // startCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });
    cc = context;

    if (isStraight) {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        off();
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
                  )
                ],
              ),
              Column(
                children: [
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton("確定", () {
                        off();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestMenuPage(),
                          ),
                        );
                      })
                    ],
                  )
                ],
              ),
              Container()
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image.asset("images/signal.png"),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: GestureDetector(
                                onTap: () {
                                  off();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeMenuPage()));
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
                        flex: 1,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: sizeHeight * 0.8,
                              child: previewCamera,
                            ),
                            CustomButton("確定", () {
                              off();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestMenuPage(),
                                ),
                              );
                            })
                          ],
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Image.asset("images/signal.png"),
                        flex: 1,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    print("-----------");
    print("camera preview widget");
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
    controller = CameraController(cameraDescription, ResolutionPreset.medium,
        enableAudio: false);

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
