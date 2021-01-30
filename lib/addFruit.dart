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
            backgroundColor: Colors.white,//Color.fromRGBO(254, 246, 227, 1),
            body: Center(
              child: Stack(
                alignment: const Alignment(0, 0.7),
                children: [
                  Image.asset("images/prompt.png"),
                  GestureDetector(
                    onTap: () {
                      dataBean.step = 2;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraApp(dataBean),
                        ),
                      );
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Color.fromRGBO(248, 203, 173, 1), width: 5),
                        color: Color.fromRGBO(255, 242, 204, 1),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(15),
                      ),
                      child: Text(
                        "繼續檢測",
                        style: TextStyle(
                            fontSize: 25, color: Color.fromRGBO(105, 57, 8, 1)),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  )
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
  print("enter main");
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();

    print(cameras.length);
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
}
