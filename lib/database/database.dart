import 'dart:io';

import 'package:crud_sqlite_app/models/note_model.dart';
import 'package:crud_sqlite_app/models/user_model.dart';
import 'package:crud_sqlite_app/screens/user_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  static Database? _db = null;
  DatabaseHelper._instance();

  String noteTable = 'note_table';
  String userTable = 'user_table';
  String iD = 'id';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';
  String firstName = 'firstname';
  String lastName = 'lastname';
  String gender = 'gender';
  String age = 'age';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  Future<Database?> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_List.db';
    final todoListDB =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return todoListDB;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)');
    await db.execute(
        'CREATE TABLE $userTable($iD INTEGER PRIMARY KEY AUTOINCREMENT, $firstName TEXT, $lastName TEXT, $gender TEXT, $age INTEGER, $colStatus INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await this.db;

    final List<Map<String, dynamic>> result = await db!.query(noteTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database? db = await this.db;

    final List<Map<String, dynamic>> result = await db!.query(userTable);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();

    final List<Note> noteList = [];

    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));
    });
    noteList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));
    return noteList;
  }

  Future<List<User>> getUserList() async {
    final List<Map<String, dynamic>> userMapList = await getUserMapList();

    final List<User> userList = [];

    userMapList.forEach((userMap) {
      userList.add(User.fromMap(userMap));
    });

    return userList;
  }

  Future<int> insertNote(Note note) async {
    Database? db = await this.db;

    final int result = await db!.insert(
      noteTable,
      note.toMap(),
    );
    return result;
  }

  Future<int> insertUser(User user) async {
    Database? db = await this.db;

    final int result = await db!.insert(
      userTable,
      user.toMap(),
    );
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database? db = await this.db;

    final int result = await db!.update(noteTable, note.toMap(),
        where: '$colId= ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> updateUser(User user) async {
    Database? db = await this.db;

    final int result = await db!
        .update(userTable, user.toMap(), where: '$iD= ?', whereArgs: [user.iD]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database? db = await this.db;

    final int result =
        await db!.delete(noteTable, where: '$colId= ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteUser(int iD) async {
    Database? db = await this.db;

    final int result =
        await db!.delete(userTable, where: '$iD= ?', whereArgs: [iD]);
    return result;
  }
}
