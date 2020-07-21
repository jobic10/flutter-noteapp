import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/utils/constants.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/functions.dart';
import 'package:noteapp/utils/language.dart';

class AllNotes extends StatefulWidget {
  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  DBHelp db = DBHelp();
  List<Note> notes = List<Note>();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: allNoteKey,
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1));
                },
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.ac_unit),
                        title: Text(
                          data.note.length > 80
                              ? data.note.toString().substring(0, 80) + " ..."
                              : data.note,
                          style: TextStyle(
                            color: kCategoryList[data.category],
                          ),
                        ),
                        onTap: () {
                          print("My id is ${data.id}");
                        },
                        subtitle: Text(data.category),
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
                ),
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
              push(context: context, route: "/404");
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: Language.addNewNoteButtonHint,
        onPressed: () {
          push(context: context, route: "/add");
        },
      ),
    );
  }
}
