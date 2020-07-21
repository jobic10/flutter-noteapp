import 'package:flutter/widgets.dart';
import 'package:noteapp/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelp {
  static DBHelp _dbHelper;
  Database db;
  DBHelp._createInstance();
  final String tableName = "tbl_note";
  final String tableId = "id";
  final String tableCategory = "category";
  final String tableDate = "entry_date";
  final String tableNote = "note";

  factory DBHelp() {
    if (_dbHelper == null) _dbHelper = DBHelp._createInstance();
    return _dbHelper;
  }
  Future<Database> open() async {
    String path = join(await getDatabasesPath(), 'noteDb.db');

    Database noteDB = await openDatabase(
      path,
      onCreate: (db, version) => createDB(database: db, version: version),
      onOpen: (db) => openCheck(database: db),
      version: 1,
    );
    return noteDB;
  }

  Future<void> openCheck({@required Database database, int version}) async {
    try {
      await database.rawQuery("SELECT * FROM  $tableName LIMIT 1");
    } catch (e) {
      await createDB(database: database);
    }
  }

  Future<void> createDB({@required Database database, int version}) async {
    await database.execute("DROP TABLE IF EXISTS $tableName");
    await database.execute("""
    CREATE TABLE $tableName(
$tableId INTEGER PRIMARY KEY autoincrement,
$tableNote TEXT,
$tableCategory VARCHAR(40),
$tableDate VARCHAR(50)
);""");
    print("Created Database");
  }

  Future<List<Note>> getNote() async {
    Database db = await this.open();

    var notesFromDB = await db.query(tableName);
    List<Note> notes = List<Note>();
    for (var note in notesFromDB) notes.add(Note.fromMap(note));
    return notes;
  }

  Future<int> add(Note note) async {
    Database db = await this.open();
    // if (_dbHelper == null) await open();
    // print(note.toMap());
    try {
      int res = await db.insert(tableName, note.toMap());
      print("Okay, the insert returned => $res");
      return res;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<void> deleteById(int id) async {
    assert(id > 0 && id < (double.maxFinite));
    Database db = await this.open();
    return await db.delete(tableName, where: "$tableId = ?", whereArgs: [id]);
  }
}
