// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'sqlLite.dart';

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
          backgroundColor: ItemTheme.bgColor,
          body: Container(
            child: RecordWidget(),
          ));
  }
}

class RecordWidget extends StatefulWidget {
  RecordWidget({Key key}) : super(key: key);

  @override
  RecordState createState() => RecordState();
}

class RecordState extends State<RecordWidget> {
  List<FunHeart> data = new List.empty(growable: true);

  bool isStraight = false;
  DataBean dataBean = new DataBean();
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  BoxDecoration boxDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 242, 204, 1),
      border: Border.all(color: Color.fromRGBO(248, 203, 173, 1), width: 2));
  FunHeartProvider funHeartProvider = new FunHeartProvider();

  Widget createText(String s){
    return(Text(s,style: TextStyle(fontSize: 20),));
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      getData();
    }
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            isStraight ? 5 : iconSize, 5, isStraight ? 5 : iconSize, 5),
        color: Color.fromRGBO(255, 245, 227, 1),
        height: sizeHeight,
        width: sizeWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBtn(
                  edgeInsets: EdgeInsets.fromLTRB(
                      isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
                  iconSize: iconSize,
                  imgStr: 'images/home.png',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            ((data.isEmpty)
                ? Container(
                    child: createText("暫無紀錄"),
                  )
                : Flexible(
                    child: ListView.builder(
                        // reverse: true,
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
                                        children: [createText("測驗時間")],
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: createText(data[index].time),
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
                                          createText("蔬果種類")
                                        ],
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: createText(data[index].fruitClass),
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
                                            createText("購買地點"),
                                          ],
                                        )),
                                    Flexible(
                                        flex: 3, child: createText(data[index].area))
                                  ],
                                ),
                                (data[index].name.isEmpty
                                    ? Container()
                                    : Row(
                                        children: [
                                          Flexible(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "images/inputTime.png",
                                                    width: 30,
                                                  ),
                                                  createText("蔬果名稱")
                                                ],
                                              )),
                                          Flexible(
                                            flex: 3,
                                            child: createText(data[index].name),
                                          ),
                                        ],
                                      )),
                                Row(
                                  children: [
                                    Flexible(
                                        flex: 2,
                                        child: Row(
                                          children: [createText("蔬果抑制率")],
                                        )),
                                    Flexible(
                                      flex: 3,
                                      child: createText(
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
                  ))
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    // Fetch the available cameras before initializing the app.

    await funHeartProvider.open();
    data.clear();
    await funHeartProvider.getFunHeartList().then((value) {
      setState(() {
        data = value.reversed.toList();
      });
    });
    // funHeartProvider.getFunHeart().then((value) {
    //   for (var item in value) {
    //     data.add(FunHeart.fromMap(item));
    //   }
    // });
  }
}
