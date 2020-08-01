import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/utils/constants.dart';

class ViewNote extends StatelessWidget {
  final Note note;
  ViewNote({@required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Viewing Note"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed("/add", arguments: note);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
              child: Text(
            note.category,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                color: kCategoryList[note.category],
                fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Card(
                child: Text(
              note.note,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            )),
          ),
        ],
      ),
    );
  }
}
