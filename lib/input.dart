// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manual_camera/camera.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'home.dart';
import 'test.dart';

class TestInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getCamera();
    return Scaffold(backgroundColor: ItemTheme.bgColor, body: InputWidget());
  }
}

class InputWidget extends StatefulWidget {
  InputWidget({Key key}) : super(key: key);

  @override
  InputPageState createState() => InputPageState();
}

class InputPageState extends State<InputWidget> {
  bool isStraight = false;
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  final TextEditingController fruitNameController = new TextEditingController();
  DataBean dataBean = new DataBean();
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
  String dateTime = formatDate(
          DateTime.now(), [yyyy, '-', mm, '-', dd, " ", HH, ':', nn, ':', ss])
      .toString();

  BoxDecoration boxDecoration = BoxDecoration(
      color: Color.fromRGBO(255, 242, 204, 1),
      border: Border.all(color: Color.fromRGBO(248, 203, 173, 1), width: 2));

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });

    Widget homeButton = Padding(
      padding:
          EdgeInsets.fromLTRB(isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeMenuPage()));
        },
        child: Image.asset(
          'images/home.png',
          height: iconSize,
          width: iconSize,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget sureButton = Center(
      child: CustomButton(
        "確定",
        () {
          if (area != "" && item != "") {
            dataBean.cameras = cameras;
            dataBean.step = 1;
            dataBean.time = dateTime;
            dataBean.fruitClass = item;
            dataBean.area = area;
            dataBean.fruitName = fruitNameController.text;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CameraApp(dataBean: dataBean),
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
      ),
    );

    Widget classDown = DropdownButton<String>(
      hint: Container(
        width: 150,
        child: Center(
          child: Text(item == "" ? "請選擇檢測蔬果" : item),
        ),
      ),
      items: items.map((String value) {
        return new DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(value),
            ));
      }).toList(),
      onChanged: (value) {
        setState(() {
          item = value;
        });
      },
    );
    Widget areaDown = DropdownButton<String>(
      hint: Container(
        width: 150,
        child: Center(
          child: Text(area == "" ? "請選擇購買地點" : area),
        ),
      ),
      items: areas.map((String value) {
        return new DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(value),
            ));
      }).toList(),
      onChanged: (value) {
        setState(() {
          area = value;
        });
      },
    );
    AutoSizeGroup subTitleGroup = AutoSizeGroup();

    AutoSizeGroup subTitleGroupH = AutoSizeGroup();
    if (isStraight) {
      return SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          color: Color.fromRGBO(255, 245, 227, 1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [homeButton],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: (Padding(
                        padding: EdgeInsets.all(10),
                        child: AutoSizeText(
                          "檢測小筆記",
                          maxLines: 1,
                          style: TextStyle(fontSize: 50),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    )
                  ],
                ),
                Expanded(
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: sizeWidth * 0.7,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/inputClass.png',
                                        width: sizeWidth * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                      // AutoTextChange(w: sizeWidth*0.5,s: "檢測蔬果",paddingW: 0,paddingH: 0,),
                                      Expanded(
                                        child: AutoSizeText(
                                          "檢測蔬果",
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 30),
                                          group: subTitleGroup,
                                        ),
                                      )
                                    ],
                                  ),
                                  classDown,
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/inputArea.png',
                                        width: sizeWidth * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          "來自/購買地區",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                          group: subTitleGroup,
                                        ),
                                      )
                                    ],
                                  ),
                                  areaDown,
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/inputTime.png',
                                        width: sizeWidth * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          "蔬菜名稱",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                          group: subTitleGroup,
                                        ),
                                      )
                                    ],
                                  ),
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: "(選填)"),
                                    controller: fruitNameController,
                                    autofocus: false,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                sureButton
              ],
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Container(
          color: Color.fromRGBO(255, 245, 227, 1),
          padding: EdgeInsets.fromLTRB(iconSize, 5, iconSize, 5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    homeButton,
                    Expanded(
                      child: (Padding(
                        padding: EdgeInsets.all(10),
                        child: AutoSizeText(
                          "檢測小筆記",
                          maxLines: 1,
                          style: TextStyle(fontSize: 50),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    )
                  ],
                ),
                Expanded(
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          width: sizeWidth * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: SizedBox(
                                        // height: sizeHeight * 0.3,
                                        width: sizeWidth * 0.3,
                                        child: AutoSizeText(
                                          "蔬果種類",
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 30),
                                          group: subTitleGroupH,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: SizedBox(
                                        // height: sizeHeight * 0.3,
                                        width: sizeWidth * 0.3,
                                        child: AutoSizeText(
                                          "來自/購買地點",
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 30),
                                          textAlign: TextAlign.center,
                                          group: subTitleGroupH,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: SizedBox(
                                        // height: sizeHeight * 0.3,
                                        width: sizeWidth * 0.3,
                                        child: AutoSizeText(
                                          "蔬果名稱",
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 30),
                                          group: subTitleGroupH,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: classDown,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: areaDown,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: TextField(
                                        decoration:
                                            InputDecoration(hintText: "(選填)"),
                                        controller: fruitNameController,
                                        autofocus: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        'images/inputClass.png',
                                        width: min(
                                            sizeWidth * 0.2, sizeHeight * 0.3),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        'images/inputArea.png',
                                        width: min(
                                            sizeWidth * 0.2, sizeHeight * 0.3),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Image.asset(
                                        'images/inputTime.png',
                                        width: min(
                                            sizeWidth * 0.2, sizeHeight * 0.3),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [sureButton],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

List<CameraDescription> cameras = [];

Future<void> getCamera() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code + "\nError Message" + e.description);
  }
}
