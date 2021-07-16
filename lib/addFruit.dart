// Flutter imports:
import 'package:flutter/material.dart';

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
  MediaData mediaData=new MediaData();  
  DataBean dataBean;
  AddFruitPageState(DataBean d) {
    dataBean = d;
  }

  @override
  Widget build(BuildContext context) {
    this.setState(() {
     mediaData.update(context);
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
    if (mediaData.isStraight) {
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


