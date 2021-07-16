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
  MediaData mediaData = new MediaData();
  DataBean dataBean = new DataBean();
  BoxDecoration boxDecoration = BoxDecoration(
      color: ItemTheme.offbeatColor,
      border: Border.all(color: ItemTheme.leatherColor, width: 2));
  FunHeartProvider funHeartProvider = new FunHeartProvider();

  Widget createText(String s) {
    return (Text(
      s,
      style: TextStyle(fontSize: 20),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      getData();
    }
    this.setState(() => mediaData.update(context));

    return SafeArea(
      child: Container(
        padding: mediaData.getPaddingIconSizeOrFive(),
        color: ItemTheme.bgColor,
        height: mediaData.sizeHeight,
        width: mediaData.sizeWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBtn(
                  edgeInsets: mediaData.getPaddingFiveOrZero(),
                  iconSize: mediaData.iconSize,
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
                                        flex: 3,
                                        child: createText(data[index].area))
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
