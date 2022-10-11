import 'package:crud_sqlite_app/database/database.dart';
import 'package:crud_sqlite_app/models/user_model.dart';
import 'package:crud_sqlite_app/screens/user_data.dart';
import 'package:flutter/material.dart';

class UserDisplay extends StatefulWidget {
  final User? user;
  final Function? updateUserList;

  UserDisplay({this.user, this.updateUserList});

  @override
  State<UserDisplay> createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = "";
  String _lastName = "";
  String _age = "";
  String _gender = 'Select';
  String btnText = 'Add User';
  String titleText = 'Add  New User';

  final List<String> _genders = ['Select', 'Male', 'Female', 'Others'];

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _firstName = widget.user!.firstName!;
      _lastName = widget.user!.lastName!;
      _age = widget.user!.age!;

      _gender = widget.user!.gender!;

      setState(() {
        btnText = 'Update User';
        titleText = 'Update User';
      });
    } else {
      setState(() {
        btnText = 'Add User';
        titleText = 'Add User';
      });
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteUser(widget.user!.iD!);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => UserData()));

    widget.updateUserList!();
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_firstName, $_lastName, $_age, $_gender');

      User user = User(
          firstName: _firstName,
          lastName: _lastName,
          age: _age,
          gender: _gender);

      if (widget.user == null) {
        user.status = 0;
        DatabaseHelper.instance.insertUser(user);
        widget.updateUserList!();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserData()));
      } else {
        user.iD = widget.user!.iD;
        user.status = widget.user!.status;
        DatabaseHelper.instance.updateUser(user);
        widget.updateUserList!();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserData()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserData())),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  titleText,
                  style: TextStyle(
                    color: Color(0xADDF223D),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please enter your first name'
                              : null,
                          onSaved: (input) => _firstName = input!,
                          initialValue: _firstName,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please enter your last name'
                              : null,
                          onSaved: (input) => _lastName = input!,
                          initialValue: _lastName,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please enter your age'
                              : null,
                          onSaved: (input) => _age = input!,
                          initialValue: _age,
                        ),
                      ),

                      //THE GENDER DROPDOWN
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _genders.map((String gender) {
                            return DropdownMenuItem(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ));
                          }).toList(),
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          validator: (input) => _gender == null
                              ? 'Please select appropriate gender'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _gender = value.toString();
                            });
                          },
                          value: _gender,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              btnText,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                      ),
                      widget.user != null
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ElevatedButton(
                                  onPressed: _delete,
                                  child: Text(
                                    'Delete User',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
