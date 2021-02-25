import 'dart:ui';
import 'package:fun_Heart_eat/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'customeItem.dart';

class SettingPage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ItemTheme.themeData,
      home: Setting(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }
}

class SettingState extends State<Setting> {
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
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(5),
        color: Color.fromRGBO(255, 245, 227, 1),
        child: Column(
          children: [
            Row(
              children: [Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeMenuPage()));
                },
                child: Image.asset(
                  'images/home.png',
                  height: iconSize,
                  width: iconSize,
                  fit: BoxFit.cover,
                ),
              ),
            )],
            ),
            Row(
              children: [
                Text("有無鈴聲"),
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
                Text("有無震動"),
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
