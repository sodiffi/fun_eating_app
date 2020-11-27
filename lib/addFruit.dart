// import 'dart:html';

import 'dart:ui';
import 'package:flutter_app/test.dart';
import 'package:flutter_better_camera/camera.dart';
import 'home.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddFruit extends StatelessWidget {
  List before;
  AddFruit(List b){
    before=b;
  }

  @override
  Widget build(BuildContext context) {
    main();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "openhuninn",
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color.fromRGBO(255, 245, 227, 1),
              shape: RoundedRectangleBorder(),
              elevation: 0,
            )),
        home: Scaffold(
            backgroundColor: Color.fromRGBO(254, 246, 227, 1),
            body: Center(
              child:
              Stack(
                alignment: const Alignment(0, 0.5),

                children: [
                  Image.asset("images/prompt.png"),
                FlatButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>CameraApp.second(2, cameras,before)));
                }, child: Text("添加完畢"))
                ],
              )
            )
        ));
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