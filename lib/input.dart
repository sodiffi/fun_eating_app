import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/screenArgs.dart';
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
    "台北市",
    "新北市",
    "桃園市",
    "新竹縣",
    "新竹市",
    "苗栗縣",
    "南投縣",
    "雲林縣",
    "嘉義縣",
    "台南市",
    "高雄市",
    "台中市",
    "彰化縣",
    "屏東縣",
    "宜蘭縣",
    "花蓮縣",
    "台東縣",
    "澎湖縣",
    "金門縣",
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

    double sizeWidth = isStraight
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    main();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 245, 227, 1),
      body: Center(
        child: Container(
          height: sizeHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Flex(direction: Axis.horizontal,children: [
                Expanded(child: Container(),flex: 1,),
                Image.asset(
                  "images/note.png",
                  height: 50,
                ), Text(
                  "檢測小筆記",
                  // style: Theme.of(context).textTheme.headline1,
                ),Expanded(child: Container(),flex: 1,),
              ],),
              // Row(
              //   children: [
              //     Image.asset(
              //       "images/note.png",
              //       height: 50,
              //     ), Text(
              //       "檢測小筆記",
              //       // style: Theme.of(context).textTheme.headline1,
              //     )
              //   ],
              // ),
              // Flex(
              //   direction: Axis.horizontal,
              //   children: [
              //     isStraight ? Container() : Spacer(flex: 2),
              //     Expanded(
              //       child: Image.asset(
              //         "images/note.png",
              //         height: 50,
              //       ),
              //       flex: 1,
              //     ),
              //     Expanded(
              //       child: Text(
              //         "檢測小筆記",
              //         // style: Theme.of(context).textTheme.headline1,
              //       ),
              //       flex: 3,
              //     ),
              //     isStraight ? Container() : Spacer(flex: 2)
              //   ],
              // ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      width: isStraight ? 120 : sizeWidth * 0.38,
                      height: sizeHeight * 0.14,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: EdgeInsets.all(0),
                      decoration: boxDecoration,
                      child: Center(
                        child: Text("檢測蔬果"),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      // width: isStraight ? 175 : sizeWidth * 0.38,
                      height: sizeHeight * 0.14,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: boxDecoration,
                      child: DropdownButton<String>(
                        hint: Container(
                          width: 150,
                          child: Center(
                            child: Text(item == "" ? "請選擇檢測蔬果" : item),
                          ),
                        ),
                        items: items.map((String value) {
                          return new DropdownMenuItem<String>(
                              value: value, child: Center(child: Text(value),));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            item = value;
                          });
                        },
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      width: isStraight ? 100 : sizeWidth * 0.38,
                      height: sizeHeight * 0.14,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: boxDecoration,
                      child: Center(
                        child: Text("來自/購買地區"),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      // width: isStraight ? 50 : sizeWidth * 0.38,
                      height: sizeHeight * 0.14,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: boxDecoration,
                      child: DropdownButton<String>(
                        hint: Container(
                          width: 150,
                          child: Center(
                            child: Text(area == "" ? "請選擇購買地點" : area),
                          ),
                        ),
                        items: areas.map((String value) {
                          return new DropdownMenuItem<String>(
                              value: value, child: Center(child: Text(value),));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            area = value;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              // Row(
              //   // mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: isStraight ? 120 : sizeWidth * 0.38,
              //       height: sizeHeight * 0.14,
              //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //       padding: EdgeInsets.all(10),
              //       decoration: boxDecoration,
              //       child: Text("檢測蔬果"),
              //     ),
              //     Container(
              //       width: isStraight ? 175 : sizeWidth * 0.38,
              //       height: sizeHeight * 0.14,
              //       padding: EdgeInsets.all(0),
              //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //       decoration: boxDecoration,
              //       child: DropdownButton<String>(
              //         hint: Container(
              //           width: 1,
              //           child: Text(item == "" ? "請選擇檢測蔬果" : item),
              //         ),
              //         items: items.map((String value) {
              //           return new DropdownMenuItem<String>(
              //               value: value, child: Text(value));
              //         }).toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             item = value;
              //           });
              //         },
              //       ),
              //     )
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: isStraight ? 100 : sizeWidth * 0.38,
              //       height: sizeHeight * 0.14,
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //       decoration: boxDecoration,
              //       child: Text("來自/購買地區"),
              //     ),
              //     Container(
              //       width: isStraight ? 50 : sizeWidth * 0.38,
              //       height: sizeHeight * 0.14,
              //       padding: EdgeInsets.all(0),
              //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //       decoration: boxDecoration,
              //       child: DropdownButton<String>(
              //         hint: Container(
              //           width: 150,
              //           child: Text(area == "" ? "請選擇購買地點" : area),
              //         ),
              //         items: areas.map((String value) {
              //           return new DropdownMenuItem<String>(
              //               value: value, child: Text(value));
              //         }).toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             area = value;
              //           });
              //         },
              //       ),
              //     )
              //   ],
              // ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      width: isStraight ? 50 : sizeWidth * 0.38,
                      height: sizeHeight * 0.14,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: boxDecoration,
                      child: Center(
                        child: Text("時間"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: sizeWidth * 0.38,
                      height: sizeHeight * 0.14,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: boxDecoration,
                      child: Center(
                        child: Text(formatDate(DateTime.now(), [
                          yyyy,
                          '-',
                          mm,
                          '-',
                          dd,
                          " ",
                          HH,
                          ':',
                          nn,
                          ':',
                          ss
                        ])),
                      ),
                    ),
                  )
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: isStraight ? 50 : sizeWidth * 0.38,
              //       height: sizeHeight * 0.14,
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //       decoration: boxDecoration,
              //       child: Text("時間"),
              //     ),
              //     Container(
              //       width: sizeWidth * 0.38,
              //       height: sizeHeight * 0.14,
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //       decoration: boxDecoration,
              //       child: Text(formatDate(DateTime.now(),
              //           [yyyy, '-', mm, '-', dd, " ", HH, ':', nn, ':', ss])),
              //     ),
              //   ],
              // ),
              FlatButton(
                  onPressed: () {
                    if (area != "" && item != "") {
                      // Navigator.pushNamed(context, "/test",
                      //     arguments: ScreenArgs.first(1, cameras));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraApp(1, cameras),
                        ),
                      );
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
