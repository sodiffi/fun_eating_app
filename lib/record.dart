import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/dataBean.dart';
import 'package:flutter_app/sqlLite.dart';
import 'test.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "openhuninn",
          textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 20),
              subtitle1: TextStyle(fontSize: 20),
              headline1: TextStyle(fontSize: 30, color: Colors.black))),
      home: Scaffold(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          body: Container(
            child: RecordWidget(),
          )),
    );
  }
}

class RecordWidget extends StatefulWidget {
  RecordWidget({Key key}) : super(key: key);

  @override
  RecordState createState() => RecordState();
}

class RecordState extends State<RecordWidget> {
  bool isStraight = false;
  DataBean dataBean = new DataBean();
  BoxDecoration boxDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 242, 204, 1),
      border: Border.all(color: Color.fromRGBO(248, 203, 173, 1), width: 2));

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    });
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        color: Color.fromRGBO(255, 245, 227, 1),
        height: sizeHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
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
                )
              ],
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Center(
                            child: Text("時間"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(data[index].time),
                          ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Center(
                            child: Text("蔬果種類"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(data[index].fruitClass),
                          ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Center(
                            child: Text("購買地點"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(data[index].area),
                          ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Center(
                            child: Text("蔬果汁抑制率"),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(data[index].rate.toString() + "%"),
                          ))
                        ],
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}

List<FunHeart> data;

Future<void> getData() async {
  // Fetch the available cameras before initializing the app.
  FunHeartProvider funHeartProvider = new FunHeartProvider();
  await funHeartProvider.open();
  data = new List();
  var it;
  await funHeartProvider.getFunHeart().then((value) {
    for (var item in value) {
      data.add(FunHeart.fromMap(item));
    }
  });
}
