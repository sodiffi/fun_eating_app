// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'customeItem.dart';

class TrainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ItemTheme.bgColor,
      body: new ListView(
        children: <Widget>[
          new Image.asset("images/train/step1_pic.png"),
          new Image.asset("images/train/step2_pic.png"),
          new Image.asset("images/train/step3_pic.png"),
          new Image.asset("images/train/step4_pic.png"),
          new Image.asset("images/train/step5_pic.png"),
          new Image.asset("images/train/step6_pic.png"),
          new Image.asset("images/train/step7_pic.png"),
          Center(
            child: CustomButton("確定", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestMenuPage(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
