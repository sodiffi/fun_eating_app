// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// import 'package:flutter_better_camera/camera.dart';
import 'package:manual_camera/camera.dart';

// Project imports:
import 'customeItem.dart';
import 'dataBean.dart';
import 'test.dart';

class AddFruit extends StatefulWidget {
  final DataBean dataBean;
  AddFruit({Key key, @required this.dataBean}) : super(key: key);

  @override
  AddFruitPageState createState() => AddFruitPageState(dataBean);
}

class AddFruitPageState extends State<AddFruit> {
  bool isStraight = false;
  double sizeHeight;
  double sizeWidth;
  double iconSize;
  DataBean dataBean;
  AddFruitPageState(DataBean d) {
    dataBean = d;
  }

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });
    List<Widget> items = [
      Image.asset("images/prompt.jpg"),
      CustomButton("繼續檢測", () {
        dataBean.step = 2;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CameraApp(dataBean: dataBean),
          ),
        );
      })
    ];
    if (isStraight) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        ),
        color: Colors.white,
      );
    } else {
      return Container(
        child: Stack(alignment: const Alignment(0, 0.9), children: items),
        color: Colors.white,
      );
    }
  }
}


