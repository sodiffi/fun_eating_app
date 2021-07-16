// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: "openhuninn",
    backgroundColor: Color.fromRGBO(254, 246, 227, 1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(254, 246, 227, 1),
      shape: RoundedRectangleBorder(),
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 18,
          color: Colors.black,
          backgroundColor: Colors.transparent),
      subtitle1:
          TextStyle(color: Colors.black, backgroundColor: Colors.transparent),
      button: TextStyle(
          fontSize: 20,
          color: Colors.black,
          backgroundColor: Colors.transparent),
    ),
  );

  static Color bgColor = Color.fromRGBO(254, 246, 227, 1);

  static TextStyle textStyle = TextStyle(
    color: Colors.black,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal,
    fontFamily: "openhuninn",
  );
}

class AutoTextChange extends StatefulWidget {
  final double w;
  final String s;
  final double paddingW;
  final double paddingH;
  AutoTextChange({Key key, this.w, this.s, this.paddingW, this.paddingH})
      : super(key: key);

  @override
  AutoTextChangeState createState() {
    return AutoTextChangeState();
  }
}

class AutoTextChangeGroup extends AutoTextChange {
  final AutoSizeGroup autoSizeGroup;
  AutoTextChangeGroup(
      {final double w,
      final String s,
      final double paddingW,
      final double paddingH,
      final this.autoSizeGroup})
      : super(w: w, s: s, paddingH: paddingH, paddingW: paddingW);
}

class AutoTextChangeState extends State<AutoTextChange> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.w,
      child: AutoSizeText(
        this.widget.s,
        maxLines: 1,
        style: ItemTheme.textStyle,
        textAlign: TextAlign.center,
      ),
      padding: EdgeInsets.fromLTRB(this.widget.paddingW, this.widget.paddingH,
          this.widget.paddingW, this.widget.paddingH),
    );
  }
}

class AutoTextChangesGroup extends State<AutoTextChangeGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.w,
      child: AutoSizeText(this.widget.s,
          maxLines: 1,
          style: ItemTheme.textStyle,
          textAlign: TextAlign.center,
          group: this.widget.autoSizeGroup),
      padding: EdgeInsets.fromLTRB(this.widget.paddingW, this.widget.paddingH,
          this.widget.paddingW, this.widget.paddingH),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton(this.text, this.onPressed);
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return (OutlineButton(
      onPressed: onPressed,
      child: Text(text),
      textColor: Color.fromRGBO(105, 57, 8, 1),
      color: Color.fromRGBO(255, 242, 204, 1),
      highlightedBorderColor: Color.fromRGBO(105, 57, 8, 1),
      borderSide: BorderSide(
        color: Color.fromRGBO(248, 203, 173, 1),
        width: 3,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ));
  }
}

class LaunchUrl {
  static launchU(u) async {
    if (await canLaunch(u)) {
      await launch(u);
    } else {
      throw 'Could not launch $u';
    }
  }

  static Future<dynamic> knowledge() =>
      launchU("http://www.labinhand.com.tw/new.html");
  static Future<dynamic> shop() =>
      launchU("http://www.labinhand.com.tw/FUNshop.html");
  static Future<dynamic> connection() =>
      launchU("http://www.labinhand.com.tw/connection.html");
  static Future<dynamic> map() =>
      launchU("http://www.labinhand.com.tw/FUNmaps.html");
}

class IconBtn extends StatefulWidget {
  final EdgeInsets edgeInsets;
  final double iconSize;
  final String imgStr;
  final Function onTap;

  const IconBtn(
      {Key key, this.edgeInsets, this.onTap, this.iconSize, this.imgStr})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return IconBtnState();
  }
}

class IconBtnState extends State<IconBtn> {
  @override
  Widget build(BuildContext context) {
    return (Padding(
      padding: this.widget.edgeInsets,
      child: GestureDetector(
          onTap: this.widget.onTap,
          child: Image.asset(
            this.widget.imgStr,
            height: this.widget.iconSize,
            width: this.widget.iconSize,
            fit: BoxFit.cover,
          )),
    ));
  }
}

class LinkBtn extends StatefulWidget {
  final double linkSize;
  final AutoSizeGroup autoSizeGroup;
  final String text;
  final Function onTap;
  const LinkBtn(
      {Key key, this.linkSize, this.autoSizeGroup, this.text, this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LinkBtnState();
  }
}

class LinkBtnState extends State<LinkBtn> {
  @override
  Widget build(BuildContext context) {
    return (Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: this.widget.onTap,
          child: Stack(
            alignment: const Alignment(0, 0),
            children: [
              Image.asset(
                "images/txtBox.png",
                width: this.widget.linkSize,
                fit: BoxFit.cover,
              ),
              AutoTextChangeGroup(
                  w: this.widget.linkSize,
                  s: this.widget.text,
                  paddingW: this.widget.linkSize * 0.14,
                  paddingH: 0,
                  autoSizeGroup: this.widget.autoSizeGroup),
            ],
          ),
        ),
      ),
    ));
  }
}

class MediaData {
  double sizeHeight;
  double sizeWidth;
  double iconSize = 30;
  bool isStraight = false;
  void update(BuildContext context) {
    isStraight = MediaQuery.of(context).orientation == Orientation.portrait;
    sizeHeight = MediaQuery.of(context).size.height;
    sizeWidth = MediaQuery.of(context).size.width;
    iconSize = isStraight ? sizeWidth / 7 : sizeHeight * 0.15;
  }

  EdgeInsets getPaddingIconSizeOrFive() {
    return EdgeInsets.fromLTRB(
        isStraight ? 5 : iconSize, 5, isStraight ? 5 : iconSize, 5);
  }
  EdgeInsets getPaddingFiveOrZero() {
    return EdgeInsets.fromLTRB(
        isStraight ? 5 : 0, 5, isStraight ? 5 : 0, 5);
  }
}
