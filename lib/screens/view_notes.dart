import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/utils/constants.dart';

class ViewNote extends StatefulWidget {
  Note note;
  ViewNote({@required this.note});

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(
          "Viewing Note",
          style: kAppTitleStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed("/add", arguments: widget.note)
                  .then((value) {
                if (value != null) {
                  key.currentState.showSnackBar(SnackBar(
                    content: Text("Note Updated"),
                  ));
                  widget.note = value;
                  setState(() {});
                }
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
              child: Text(
            widget.note.category,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                color: kCategoryList[widget.note.category],
                fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Card(
                child: Text(
              widget.note.note,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
