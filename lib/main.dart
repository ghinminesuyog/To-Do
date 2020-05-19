import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'todo_list.dart';
import 'settings.dart';

void main() {
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MyApp());
}

var myTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  // fontFamily: 'DancingScript',
  primaryTextTheme: TextTheme(
    caption: TextStyle(color: Colors.white),
    overline: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white),
  ),
);

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Widget> _screens = [MyHomePage(), SettingsScreen()];
  var _currentIndex = 0;


  changeIndex(int ind) {
    setState(() {
      _currentIndex = ind;
    });
  }

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
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'To Do',
              style: TextStyle(fontSize: 28),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'To Do',
                    style: TextStyle( color: Colors.white),
                  ),
                  decoration: BoxDecoration(color: Colors.blue),
                ),
                ListTile(
                  selected: (_currentIndex == 0),
                  leading: Icon(Icons.event_note),
                  title: Text(
                    'To Do',
                  ),
                  onTap: () {
                    changeIndex(0);
                  },
                ),
                ListTile(
                  selected: (_currentIndex == 1),
                  leading: Icon(Icons.settings_applications),
                  title: Text(
                    'Settings',
                  ),
                  onTap: () {
                    changeIndex(1);
                  },
                ),
              ],
            ),
          ),
          body: _screens[_currentIndex],
        ),
      ),
    );
  }
}
