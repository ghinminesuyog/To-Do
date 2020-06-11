import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:todo/custom_classes.dart';
import 'package:todo/todolist.dart';
import 'dart:io';
import 'home_todo_list.dart';
import 'settings.dart';
import 'readAndWriteOperations.dart';

void main() {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MyApp());
}

var lightTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  // fontFamily: 'DancingScript',
  primaryTextTheme: TextTheme(
    caption: TextStyle(color: Colors.white),
    overline: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white),
  ),
);

var darkTheme = ThemeData.dark();

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool isLargeFont = false;
  String generatedListName = '';
 

  List<String> todoLists = [];

  @override
  void initState() {
    super.initState();

    readSettings();
    getTheme();
    getFont();

    getAllListNames().then((value) {
      setState(() {
        todoLists = value;
      });
    });

    readSettings().then((value) {
      setState(() {
        isDarkMode = value["dark"];
        isLargeFont = value["largeFont"];
      });
    });

    
  }

  getTheme() {
    //Listen to the stream:
    theme.stream.listen((data) {
      setState(() {
        isDarkMode = data;
      });
    });
  }

  getFont() {
    font.stream.listen((data) {
      setState(() {
        isLargeFont = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
   
   

    return MaterialApp(
      initialRoute: 'home',
      // routes: routes,
      
      title: 'To Do',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? darkTheme : lightTheme,
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}
