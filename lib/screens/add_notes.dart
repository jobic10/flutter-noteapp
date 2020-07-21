import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/utils/constants.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/functions.dart';
import 'package:noteapp/utils/language.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DBHelp db = DBHelp();
  final TextEditingController noteText = TextEditingController();
  final GlobalKey catKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String catValue = kCategoryList.keys.first;
  FocusNode _focusNode = FocusNode();
  int count = 0;

  Note myNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(Language.newNote),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                _focusNode.unfocus();

                myNote = Note(category: catValue, note: noteText.text);
                int res = await db.add(myNote); //ID of the newly inserted tuple
                if (res > 0) {
                  allNoteKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(Language.noteAdded),
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  // pop(context);
                } else {
                  showAlert(
                    context: context,
                    body: Language.noteNotAdded,
                    title: Language.noteNotAddedTitle,
                  );
                }
              }
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 2,
            color: Theme.of(context).backgroundColor,
          ),
          DropdownButtonFormField(
            value: catValue,
            onChanged: (val) {
              setState(
                () {
                  catValue = val;
                },
              );
            },
            items: kCategoryList.entries
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: InkWell(
                      child: Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                              disabledColor: e.value,
                            ),
                            child: Radio(
                              onChanged: null,
                              value: e.key,
                              groupValue: catValue,
                            ),
                          ),
                          Text(e.key),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: InkWell(
          splashColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: noteText,
                  maxLines: 8,
                  validator: (note) {
                    if (note.isNotEmpty && note.length > 10) return null;
                    return Language.smallContent;
                  },
                  keyboardType: TextInputType.multiline,
                  onChanged: (val) {
                    setState(() {
                      count = val.length;
                    });
                  },
                  focusNode: _focusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: Language.addNewNote,
                      border: InputBorder.none,
                      counterText:
                          "$count ${Language.characterCounter}${count < 2 ? '' : 's'}"),
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    cut: true,
                    selectAll: true,
                  ),
                  style: TextStyle(fontSize: 20, wordSpacing: 5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
