// Dart imports:
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
// import 'package:flutter_better_camera/camera.dart';
import 'package:wakelock/wakelock.dart';
import 'package:manual_camera/camera.dart';

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
  DataBean dataBean;
  Widget previewCamera = Container();
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  bool isStraight = false;

  CheckState(DataBean b) {
    dataBean = b;
    Wakelock.enable();
    open();
  }

  Future<void> off() async {
    Wakelock.disable();
    if (Platform.isAndroid) {
      controller.flash(false).catchError(logError);
    }
    // else Lamp.turnOff();
  }

  Future<void> open() async {
    if (dataBean.cameras[0] == null) {
    } else {
      await openCamera(dataBean.cameras[0]).catchError(logError);
    }
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
    off();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("check");
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      off();
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (dataBean.step == 0) open();
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
    Widget homeButton = Padding(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          off();
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: Image.asset(
          'images/home.png',
          height: iconSize,
          width: iconSize,
          fit: BoxFit.cover,
        ),
      ),
    );

    if (isStraight) {
      return Container(
        color: ItemTheme.bgColor,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [homeButton],
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
                        Navigator.pop(context);
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
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [Image.asset("images/signal.png"), homeButton],
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
        ),
      );
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text("fail");
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  Future<void> openCamera(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      iso: 0,
      shutterSpeed: 0,
      whiteBalance: WhiteBalancePreset.cloudy,
      focusDistance: 0,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        previewCamera = _cameraPreviewWidget();
      });
      Future.delayed(
        Duration(
          milliseconds: 250,
        ),
      );
      controller.flash(true);
    });

    controller.addListener(() {
      if (controller.value.hasError) {
        logError('Camera error ${controller.value.errorDescription}');
      }
    });

    // if(Platform.isIOS) Lamp.turnOn();
  }

  void _showCameraException(CameraException e) {
    print("--------");
    print("camera exception");
    logError(e.code + "\nError Message" + e.description);
    print("--------");
    // showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

void logError(var mes) => print('Error: ${mes.toString()}');
