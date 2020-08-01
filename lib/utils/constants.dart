import 'package:flutter/material.dart';
import 'package:noteapp/utils/language.dart';

final ThemeData kAppTheme = ThemeData(
    primarySwatch: Colors.orange,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
      splashColor: Colors.deepOrange,
    ),
    fontFamily: kFontItaliannoRegular,
    textTheme: TextTheme());

final String kAppName = Language.appName;
final String kErrorLink = "/\$404";
final String kFontItaliannoRegular = "Italianno";

final TextStyle kAppTitleStyle = TextStyle(
  fontFamily: kFontItaliannoRegular,
  fontSize: 30,
  fontWeight: FontWeight.bold,
);

final Map<String, Color> kCategoryList = {
  Language.catUncategorized: Colors.green,
  Language.catWork: Colors.blue,
  Language.catPersonal: Colors.teal,
  Language.catFamily: Colors.pink,
  Language.catStudy: Colors.purple
};
