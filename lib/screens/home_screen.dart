import 'package:crud_sqlite_app/database/database.dart';
import 'package:crud_sqlite_app/models/note_model.dart';
import 'package:crud_sqlite_app/screens/add_note.dart';
import 'package:crud_sqlite_app/screens/main_page.dart';
import 'package:crud_sqlite_app/screens/user_data.dart';
import 'package:crud_sqlite_app/screens/user_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart ';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
              title: Text(
                note.title!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                '${_dateFormatter.format(note.date!)}-${note.priority}',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue.shade900,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: Checkbox(
                  onChanged: (value) {
                    note.status = value! ? 1 : 0;

                    DatabaseHelper.instance.updateNote(note);
                    _updateNoteList();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: note.status == 0 ? false : true),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => AddNoteScreen(
                            updateNoteList: _updateNoteList, note: note))));
              }),
          Divider(
            height: 5.0,
            color: Colors.indigo,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => AddNoteScreen(
                          updateNoteList: _updateNoteList,
                        ))));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: _noteList,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final int completedNoteCount = snapshot.data!
                  .where((Note note) => note.status == 1)
                  .toList()
                  .length;

              return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  itemCount: int.parse(snapshot.data!.length.toString()) + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Main_Page())),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'My Notes',
                              style: TextStyle(
                                  color: Color(0xADDF223D),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '$completedNoteCount of ${snapshot.data.length}',
                              style: TextStyle(
                                  color: Color(0xADDF223D),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildNote(snapshot.data![index - 1]);
                  });
            }));
  }
}
