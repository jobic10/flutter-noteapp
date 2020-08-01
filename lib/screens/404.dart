import 'package:flutter/material.dart';
import 'package:noteapp/utils/constants.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          kAppName,
          style: kAppTitleStyle,
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ShaderMask(
            shaderCallback: (Rect bounds) => RadialGradient(
              center: Alignment.bottomRight,
              radius: 1.0,
              colors: [Colors.yellow, Colors.deepOrange],
              tileMode: TileMode.mirror,
            ).createShader(bounds),
            child: Text(
              "Oops... Page not found",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: kFontItaliannoRegular),
            ),
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      )),
    );
  }
}
