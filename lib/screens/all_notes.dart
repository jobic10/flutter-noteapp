import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/utils/constants.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/language.dart';

class AllNotes extends StatefulWidget {
  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  DBHelp db = DBHelp();
  List<Note> notes = List<Note>();
  int count = 0;
  List<int> selected = [];
  void selectThis(int id) {
    setState(() {
      selected.indexOf(id) == -1 ? selected.add(id) : selected.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Note data = snapshot.data[index];
                  bool isSelected =
                      selected.indexOf(data.id) == -1 ? false : true;

                  return Card(
                    color: isSelected
                        ? kAppTheme.primaryColor.withAlpha(200)
                        : null,
                    child: ListTile(
                      leading: Icon(selected.isNotEmpty
                          ? (isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank)
                          : Icons.ac_unit),
                      title: Text(
                        data.note.length > 80
                            ? data.note.toString().substring(0, 80) + " ..."
                            : data.note,
                        maxLines: 2,
                        style: TextStyle(
                          color: kCategoryList[data.category],
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        if (selected.isNotEmpty)
                          selectThis(data.id);
                        else
                          await Navigator.of(context)
                              .pushNamed("/edit", arguments: data)
                              .then((value) {
                            setState(() {});
                          });
                      },
                      onLongPress: () {
                        if (selected.indexOf(data.id) == -1) {
                          //Not Found
                          selectThis(data.id);
                        }
                      },
                      subtitle: Text(
                        data.category,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () async {
                          await db.deleteById(data.id);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(Language.noNote),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          Language.appTitle,
          style: kAppTitleStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/404");
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(selected.isEmpty ? Icons.add : Icons.delete),
          tooltip: Language.addNewNoteButtonHint,
          onPressed: () {
            selected.isEmpty
                ? Navigator.of(context).pushNamed("/add").then((value) {
                    if (value == true) {
                      setState(() {});
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Language.noteAdded),
                        ),
                      );
                    }
                  })
                : () async {
                    await db.deleteMultipleById(selected);
                    selected.clear();
                    setState(() {});
                  }();
          },
        ),
      ),
    );
  }
}
