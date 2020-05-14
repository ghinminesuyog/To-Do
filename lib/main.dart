import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'todo_list.dart';

void main() {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MyApp());
}

var myTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  fontFamily: 'DancingScript',
  primaryTextTheme: TextTheme(
    headline: TextStyle(color: Colors.white),
    display1: TextStyle(color: Colors.white),
    display2: TextStyle(color: Colors.white),
    display3: TextStyle(color: Colors.white),
    display4: TextStyle(color: Colors.white),
    title: TextStyle(color: Colors.white),
    subtitle: TextStyle(color: Colors.white),
    subhead: TextStyle(color: Colors.white),
    body1: TextStyle(color: Colors.white),
    body2: TextStyle(color: Colors.white),
    caption: TextStyle(color: Colors.white),
    overline: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white),
  ),
);



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Dismiss keyboard when tapped elsewhere:
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'To Do',
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        home: MyHomePage(title: 'To Do'),
      ),
    );
  }
}
