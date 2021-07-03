// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'customeItem.dart';

class CupertinoSetting extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
      child: SettingPage(),
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }
}

class SettingState extends State<SettingPage> {
  bool isRing = true;
  bool isShock = true;
  bool isStraight = false;
  static const String isRingProp = "isRing";
  static const String isShockProp = "isShock";
  double sizeHeight;
  double sizeWidth;
  double iconSize = 30;
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRing = (prefs.getBool(isRingProp) ?? true);
      isShock = (prefs.getBool(isShockProp) ?? true);
      isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
      sizeHeight = MediaQuery.of(context).size.height;
      sizeWidth = MediaQuery.of(context).size.width;
      iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
    });
  }

  Future<void> setData(String prop) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(prop, prop == isRingProp ? isRing : isShock);
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: ItemTheme.bgColor,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.fromLTRB(
            isStraight ? 5 : iconSize, 5, isStraight ? 5 : iconSize, 5),
        color: ItemTheme.bgColor,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);                     
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: AutoSizeText(
                      "設定",
                      maxLines: 1,
                      style: TextStyle(fontSize: 50),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: AutoSizeText(
                      "有無鈴聲",
                      maxLines: 1,
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Checkbox(
                    value: isRing,
                    onChanged: (value) {
                      setState(() {
                        isRing = !isRing;
                      });
                      setData(isRingProp);
                    })
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: AutoSizeText(
                      "有無震動",
                      maxLines: 1,
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Checkbox(
                    value: isShock,
                    onChanged: (value) {
                      setState(() {
                        isShock = !isShock;
                      });
                      setData(isShockProp);
                    })
              ],
            )
          ],
        ),
      )),
    );
  }
}
