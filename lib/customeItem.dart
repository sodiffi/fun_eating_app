import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  AutoSizeGroup autoSizeGroup;
  AutoTextChange({Key key, this.w, this.s, this.paddingW, this.paddingH})
      : super(key: key);
  AutoTextChange.group(
      {Key key,
      this.w,
      this.s,
      this.paddingW,
      this.paddingH,
      this.autoSizeGroup})
      : super(key: key);

  @override
  AutoTextChangeState createState() {
    return AutoTextChangeState();
  }
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
        group: this.widget.autoSizeGroup,
      ),
      padding: EdgeInsets.fromLTRB(this.widget.paddingW, this.widget.paddingH,
          this.widget.paddingW, this.widget.paddingH),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton(this.text, this.onPressed);
  var onPressed;
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
