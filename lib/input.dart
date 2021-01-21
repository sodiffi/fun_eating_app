import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/dataBean.dart';
import 'package:flutter_app/customeItem.dart';
import 'test.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TestInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getCamera();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ItemTheme.themeData,
      home: Scaffold(
          backgroundColor: Color.fromRGBO(255, 245, 227, 1),
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: InputWidget(),
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
  double sizeHeight;
  double sizeWidth;
  double iconSize;
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
      padding: EdgeInsets.all(5),
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

    Widget sureButton = FlatButton(
        onPressed: () {
          if (area != "" && item != "") {
            dataBean.cameras = cameras;
            dataBean.step = 1;
            dataBean.time = dateTime;
            dataBean.fruitClass = item;
            dataBean.area = area;
            _asyncInputDialog(context, dataBean);
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
        child: Text("確定"));

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



    if (isStraight) {
      return SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          color: Color.fromRGBO(255, 245, 227, 1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [homeButton],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/note.png",
                      height: 50,
                    ),
                    AutoSizeText(
                      "檢測小筆記",
                      maxLines: 1,
                      minFontSize: 28,

                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'images/inputClass.png',
                      width: sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                    AutoSizeText(
                      "檢測蔬果",
                      maxLines: 1,
                      minFontSize: 28,
                    )
                    // Expanded(child: Padding(padding: EdgeInsets.all(5),child: ,)),
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
                    AutoSizeText(
                      "來自/購買地區",
                      maxLines: 1,
                      minFontSize: 28,
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
                    AutoSizeText(
                      "時間",
                      maxLines: 1,
                      minFontSize: 28,
                    )
                  ],
                ),
                Text(dateTime),
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
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [homeButton],
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
                  child: Text("購買地點"),
                )),
                Expanded(
                    child: Center(
                  child: Text("測驗時間"),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    child: Text(dateTime),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Center(
                  child: Image.asset(
                    'images/inputClass.png',
                    width: sizeWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                )),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'images/inputArea.png',
                      width: sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'images/inputTime.png',
                      width: sizeWidth * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [sureButton],
            )
          ],
        ),
      ));
    }
  }
}

List<CameraDescription> cameras = [];

Future<void> getCamera() async {
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

Future _asyncInputDialog(BuildContext context, DataBean dataBean) async {
  String teamName = '';
  return showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('開始測驗'),
        content: new Row(
          children: [
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: '請輸入蔬果名稱(非必填)', hintText: '(非必填)'),
              onChanged: (value) {
                teamName = value;
              },
            ))
          ],
        ),
        actions: [
          FlatButton(
            child: Text('開始'),
            onPressed: () {
              dataBean.fruitName = teamName;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraApp(dataBean),
                ),
              );
            },
          ),
          FlatButton(
            child: Text('關閉'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );
    },
  );
}
