import 'dart:ui';
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
  bool isRing;
  bool isShock;
  static const String isRingProp = "isRing";
  static const String isShockProp = "isShock";

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRing = (prefs.getBool(isRingProp) ?? true);
      isShock = (prefs.getBool(isShockProp) ?? true);
    });
  }

  Future<void> setData(String prop) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(prop, prop == isRingProp ? isRing : isShock);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    );
  }
}
