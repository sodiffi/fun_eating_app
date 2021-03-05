import 'dart:ui';
import 'dataBean.dart';
import 'customeItem.dart';
import 'test.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddFruit extends StatelessWidget {
  DataBean dataBean = new DataBean();

  AddFruit(DataBean d) {
    dataBean = d;
  }

  @override
  Widget build(BuildContext context) {
    main();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ItemTheme.themeData,
      home: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white, //Color.fromRGBO(254, 246, 227, 1),
            body: Center(
              child: Stack(
                alignment: const Alignment(0, 0.7),
                children: [
                  Image.asset("images/prompt.png"),
                  CustomButton("繼續檢測", () {
                    dataBean.step = 2;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraApp(dataBean),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
