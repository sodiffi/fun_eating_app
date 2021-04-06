import 'dart:ui';
import 'package:fun_heart_eat/home.dart';
import 'package:fun_heart_eat/toTest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Todo extends Pages {
  @override
  TodoState createState() {
    return TodoState();
  }
}

class TodoState extends PageState {
  @override
  Widget get bb => Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
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
        ],
      );
}

class ToSettingPage extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }
}

class SettingState extends State<ToSettingPage> {
  bool isRing = true;
  bool isShock = true;
  bool isStraight = false;
  static const String isRingProp = "isRing";
  static const String isShockProp = "isShock";
  double sizeHeight;
  double sizeWidth;
  double iconSize;
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
    return Pages(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5),
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}