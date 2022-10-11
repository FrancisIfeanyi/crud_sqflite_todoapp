import 'package:crud_sqlite_app/database/database.dart';
import 'package:crud_sqlite_app/models/user_model.dart';
import 'package:crud_sqlite_app/screens/main_page.dart';
import 'package:crud_sqlite_app/screens/user_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class UserData extends StatefulWidget {
  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  late Future<List<User>> _userList;

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  initState() {
    super.initState();
    _updateUserList();
  }

  _updateUserList() {
    _userList = DatabaseHelper.instance.getUserList();
  }

  Widget _buildUser(User user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
              title: Text(
                user.firstName!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade700,
                    decoration: user.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                '${user.lastName}|${user.age}|${user.gender}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.brown,
                    decoration: user.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: Checkbox(
                  onChanged: (value) {
                    user.status = value! ? 1 : 0;

                    DatabaseHelper.instance.updateUser(user);
                    _updateUserList();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => UserData()));
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: user.status == 0 ? false : true),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => UserDisplay(
                            updateUserList: _updateUserList, user: user))));
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
      backgroundColor: Colors.indigo.shade100,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: ((context) => UserDisplay(
                        updateUserList: _updateUserList,
                      ))));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.person_add_sharp),
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: _userList,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final int completedUserCount = snapshot.data!
                    .where((User user) => user.status == 1)
                    .toList()
                    .length;

                return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    itemCount: int.parse(snapshot.data!.length.toString()) + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
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
                                'USER DATA',
                                style: TextStyle(
                                    color: Color(0xADDF223D),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '$completedUserCount of ${snapshot.data.length}',
                                style: TextStyle(
                                    color: Color(0xADDF223D),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }
                      return _buildUser(snapshot.data![index - 1]);
                    });
              })),
    );
  }
}
