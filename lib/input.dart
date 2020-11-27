// import 'dart:html';

import 'package:flutter/material.dart';
import 'train.dart';
import 'test.dart';
import 'package:flutter_better_camera/camera.dart';

// ignore: must_be_immutable
class TestInputPage extends StatelessWidget {
  int testTime = 5;

  @override
  Widget build(BuildContext context) {
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
          body: Container(
            child: Center(
              child:InputWidget(),
            ),
          )
      ),
    );
  }
}

class InputWidget extends StatefulWidget {
  InputWidget({Key key}) : super(key: key);

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputWidget> {
  List<String> items = [
    "雜糧類",
    "葉菜類",
    "根菜類",
    "果菜類",
    "蕈菜類",
    "瓜豆類",
    "水果類",
    "茶葉類",
    "乾貨類"
  ];
  List<String> areas = [
    "基隆市",
    "南投縣",
    "屏東縣",
    "台北市",
    "雲林縣",
    "宜蘭縣",
    "新北市",
    "嘉義縣",
    "花蓮縣",
    "桃園市",
    "台南市",
    "台東縣",
    "新竹縣",
    "高雄市",
    "澎湖縣",
    "新竹市",
    "台中市",
    "金門縣",
    "苗栗縣",
    "彰化縣",
    "其他"
  ];
  String item = "雜糧類";
  String area = "基隆市";


  @override
  Widget build(BuildContext context) {
    main();
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 0, childAspectRatio: 10 / 2),
      children: <Widget>[
        Row(
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: Image.asset("images/home.png"),
              heroTag: "home",
            )
          ],
        ),Row(),
        Text("檢測蔬果"),
        DropdownButton<String>(
          hint: Text("請選擇檢測蔬果"),
          value: item,
          items: items.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              item=value;
            });
          },
        ),
        Text("來自/購買地區"),
        DropdownButton<String>(
          value: area,
          items: areas.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              area = value;
            });
          },
        ),Row(
          children: [
            FlatButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>CameraApp(1, cameras)));
            }, child: Text("確定"))
          ],
        ),Row()
      ],
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