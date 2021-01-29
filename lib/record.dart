import 'package:flutter/material.dart';
import 'home.dart';
import 'dataBean.dart';
import 'sqlLite.dart';
import 'test.dart';

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("\trecordpage build");
    // getData();
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
  List<FunHeart> data = new List();

  bool isStraight = false;
  DataBean dataBean = new DataBean();
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  BoxDecoration boxDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 242, 204, 1),
      border: Border.all(color: Color.fromRGBO(248, 203, 173, 1), width: 2));

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      getData();
    }
    print("build before" + data.length.toString());
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(5),
        color: Color.fromRGBO(255, 245, 227, 1),
        height: sizeHeight,
        width: sizeWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
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
            ((!data.isEmpty)
                ? Flexible(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/inputTime.png",
                                            width: 30,
                                          ),
                                          Text("測驗時間")
                                        ],
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: Text(data[index].time),
                                      flex: 3,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/inputClass.png",
                                            width: 30,
                                          ),
                                          Text("蔬果種類")
                                        ],
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: Text(data[index].fruitClass),
                                      flex: 3,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "images/inputArea.png",
                                              width: 30,
                                            ),
                                            Text("購買地點"),
                                          ],
                                        )),
                                    Flexible(
                                        flex: 3, child: Text(data[index].area))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        flex: 2,
                                        child: Row(
                                          children: [Text("蔬果抑制率")],
                                        )),
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                          data[index].rate.toString() + "%"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffe5e5e5)))),
                          );
                        }),
                  )
                : Container(
                    child: Text("暫無紀錄"),
                  ))
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    print("getData");
    // Fetch the available cameras before initializing the app.
    FunHeartProvider funHeartProvider = new FunHeartProvider();
    await funHeartProvider.open();
    data.clear();
    await funHeartProvider.getFunHeartList().then((value) {
      print("value.length" + value.length.toString());
      setState(() {
        data = value;
      });
    });
    // funHeartProvider.getFunHeart().then((value) {
    //   for (var item in value) {
    //     data.add(FunHeart.fromMap(item));
    //   }
    // });
  }
}
