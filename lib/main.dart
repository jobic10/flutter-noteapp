import 'package:flutter/material.dart';
import 'package:noteapp/utils/constants.dart';
import 'package:noteapp/utils/route.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerate.generate,
      title: kAppName,
      theme: kAppTheme,
      initialRoute: "/",
    );
  }
}
