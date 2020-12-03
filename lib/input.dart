import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'test.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestInputPage extends StatelessWidget {
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
          ),
          textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 20),
              subtitle1: TextStyle(fontSize: 20),
              headline1: TextStyle(fontSize: 30, color: Colors.black))),
      home: Scaffold(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          body: Container(
            child: Center(
              child: InputWidget(),
            ),
          )),
    );
  }
}

class InputWidget extends StatefulWidget {
  InputWidget({Key key}) : super(key: key);

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputWidget> {
  bool isStraight = false;
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
  String item = "";
  String area = "";
  BoxDecoration boxDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 242, 204, 1),
      border: Border.all(color: Color.fromRGBO(248, 203, 173, 1), width: 2));

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    double sizeHeight = isStraight
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    main();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         
          Flex(
            direction: Axis.horizontal,
            
            children: <Widget>[
              Expanded(
                flex: isStraight ? 2 : 1,
                child: FlatButton(
                  
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeMenuPage()));
                  },
                  child: Image.asset(
                    'images/home.png',
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Spacer(flex: 8),
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              isStraight ? Container() : Spacer(flex: 2),
              Expanded(
                child: Image.asset(
                  "images/note.png",
                  height: 50,
                ),
                flex: 1,
              ),
              Expanded(
                child: Text(
                  "檢測小筆記",
                  style: Theme.of(context).textTheme.headline1,
                ),
                flex: 2,
              ),
              isStraight ? Container() : Spacer(flex: 2)
            ],
          ),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 45,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                padding: EdgeInsets.all(10),
                decoration: boxDecoration,
                child: Text("檢測蔬果"),
              ),
              Container(
                width: 180,
                height: 45,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: boxDecoration,
                child: DropdownButton<String>(
                  hint: Container(
                    width: 150,
                    child: Text(item == "" ? "請選擇檢測蔬果" : item),
                  ),
                  items: items.map((String value) {
                    return new DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      item = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 45,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: boxDecoration,
                child: Text("來自/購買地區"),
              ),
              Container(
                width: 180,
                height: 45,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: boxDecoration,
                child: DropdownButton<String>(
                  hint: Container(
                    width: 150,
                    child: Text(area == "" ? "請選擇購買地點" : area),
                  ),
                  items: areas.map((String value) {
                    return new DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      area = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 45,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: boxDecoration,
                child: Text("時間"),
              ),
              Container(
                width: 180,
                height: 45,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: boxDecoration,
                child: Text(formatDate(DateTime.now(),
                    [yyyy, '-', mm, '-', dd, " ", HH, ':', nn, ':', ss])),
              ),
            ],
          ),
          FlatButton(
              onPressed: () {
                if (area != "" && item != "") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraApp(1, cameras)));
                } else {
                  Fluttertoast.showToast(
                      msg: "請選擇蔬果類型與購買地點",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Text("確定"))
        ],
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
