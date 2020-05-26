import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'home_todo_list.dart';
import 'settings.dart';
import 'package:path_provider/path_provider.dart';

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

  _getSettingsFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/my_settings_file.txt');
  }

  readSettings() async {
    try {
      File file = await _getSettingsFile();
      var settingsString = await file.readAsString();
      var settings = jsonDecode(settingsString);
      print(settings);
      setState(() {
        isDarkMode = settings['dark'];
        isLargeFont = settings['largeFont'];
      });
    } catch (e) {
      print('Problem reading settings. $e');
    }
  }

  List<Widget> _screens = [
    MyHomePage(),
    SettingsScreen(),
  ];
  var _currentIndex = 0;

  changeIndex(int ind) {
    setState(() {
      _currentIndex = ind;
    });
  }

  @override
  void initState() {
    super.initState();

    readSettings();
    getTheme();
    getFont();
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
        theme: isDarkMode ? darkTheme : lightTheme,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'To Do',
              style: (isLargeFont) ? TextStyle(fontSize: 28) : TextStyle(),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'To Do',
                        style: (isLargeFont)
                            ? TextStyle(fontSize: 30, color: Colors.white)
                            : TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        color: Colors.white,
                        onPressed: () {
                          changeIndex(_screens.length - 1);
                        },
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(color: Colors.blue),
                ),
                ListTile(
                  selected: (_currentIndex == 0),
                  leading: Icon(Icons.event_note),
                  title: Text(
                    'To-Do',
                    style: (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
                  ),
                  onTap: () {
                    changeIndex(0);
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
