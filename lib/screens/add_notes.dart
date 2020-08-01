import 'package:flutter/material.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/utils/constants.dart';
import 'package:noteapp/utils/database.dart';
import 'package:noteapp/utils/language.dart';

class AddNote extends StatefulWidget {
  final Note note;

  AddNote({this.note});
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DBHelp db = DBHelp();
  TextEditingController noteText;
  String catValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteText = TextEditingController(
        text: widget.note == null ? null : widget.note.note);
    catValue =
        widget.note == null ? kCategoryList.keys.first : widget.note.category;
  }

  final GlobalKey catKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();
  int count = 0;
  Note myNote;
  @override
  Widget build(BuildContext context) {
    bool newNote = widget.note == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newNote ? Language.newNote : Language.editNote,
          style: kAppTitleStyle,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                _focusNode.unfocus();

                if (!newNote) {
                  myNote = Note.withId(
                      id: widget.note.id,
                      category: catValue,
                      note: noteText.text);

                  int res = await db.updateNote(myNote);
                  if (res > 0) {
                    Navigator.of(context).pop(myNote);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(Language.noteNotUpdated),
                        title: Text(Language.error),
                      ),
                    );
                  }
                } else {
                  myNote = Note(category: catValue, note: noteText.text);

                  int res =
                      await db.add(myNote); //ID of the newly inserted tuple
                  if (res > 0) {
                    Navigator.of(context).pop(true);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text("Note could not be created"),
                        title: Text("Error"),
                      ),
                    );
                  }
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
                          Text(e.key,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
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
                      errorStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      counterStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      counterText:
                          "$count ${Language.characterCounter}${count < 2 ? '' : 's'}"),
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    paste: true,
                    cut: true,
                    selectAll: true,
                  ),
                  style: TextStyle(
                    wordSpacing: 5,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
