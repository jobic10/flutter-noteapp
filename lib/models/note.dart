import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Note {
  String category;
  String note;
  String date;
  int id;

  Note({
    @required this.category,
    @required this.note,
  });
  Note.withId(
      {@required this.category, @required this.note, @required this.id});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    map['category'] = category;
    map['entry_date'] = DateFormat.yMd().format(DateTime.now());
    map['note'] = note;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.date = map['entry_date'];
    this.category = map['category'];
    this.note = map['note'];
  }
}
