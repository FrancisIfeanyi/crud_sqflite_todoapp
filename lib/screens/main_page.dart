import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crud_sqlite_app/screens/home_screen.dart';
import 'package:crud_sqlite_app/screens/user_data.dart';
import 'package:crud_sqlite_app/screens/user_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Scaffold(
        backgroundColor: Colors.teal.shade50,
        // appBar: AppBar(
        //   elevation: 10,
        //   title: Text('NOTE APP'),
        //   centerTitle: true,
        //   titleTextStyle: TextStyle(
        //     color: Colors.white,
        //     decorationThickness: 2,
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 400,
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'EDIT YOUR INTENTIONS',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'EDIT YOUR REALITY',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'EDIT YOUR TIME',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(90)),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: ((context) => UserData())));
                  },
                  child: Text(
                    'CREATE USER',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(90)),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => HomeScreen())));
                  },
                  child: Text(
                    'CREATE NOTE',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

const colorizeColors = [
  Colors.purple,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

const colorizeTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w800,
  fontFamily: 'Horizon',
);
