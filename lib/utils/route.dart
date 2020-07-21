import 'package:flutter/material.dart';
import 'package:noteapp/screens/404.dart';
import 'package:noteapp/screens/add_notes.dart';
import 'package:noteapp/screens/all_notes.dart';

class RouteGenerate {
  static Route<dynamic> generate(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => AllNotes());
      case "/add":
        return MaterialPageRoute(builder: (_) => AddNote());
      default:
        return MaterialPageRoute(builder: (_) => PageNotFound());
    }
  }
}
