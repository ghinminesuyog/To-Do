import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
TextEditingController newListName = new TextEditingController();

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool isLargeFont = false;

  List<String> todoLists = [];



  changeScreen(index) {
    setState(() {

    Widget newWidget = new ToDoListPage(listName: todoLists[index]);

      _currentIndex =
          new SelectedScreen(home: false, settings: false, listIndex: index);

      _screen =  newWidget;

      print("Wanna view: ${todoLists[index]}");

      // print("${_screen}");
    });
  }


  // List<Widget> _screens = [
  //   MyHomePage(),
  //   SettingsScreen(),
  // ];

  Widget _screen;
  SelectedScreen _currentIndex =
      SelectedScreen(home: true, settings: false, listIndex: null);

  // changeIndex(int ind) {
  //   setState(() {
  //     _currentIndex = ind;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    readSettings();
    getTheme();
    getFont();

    getAllListNames().then((value) {
      todoLists = value;
    });

    _screen = MyHomePage();

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

  Future<void> _newListDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New list'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Choose a name for the new list'),
                TextField(
                  controller: newListName,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Create'),
              // color: Colors.red,
              // textColor: Colors.white,
              onPressed: () {
                print('Create');
                Navigator.of(context).pop();
                addNewList(newListName.text);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                print('Cancel');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  addNewList(String listName) {
    print('Created $listName');
    setState(() {
      _screen = ToDoListPage(
        listName: listName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          child: StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'To Do',
                            style: (isLargeFont)
                                ? TextStyle(
                                    fontSize: 30,
                                  )
                                : TextStyle(),
                          ),
                          IconButton(
                            icon: Icon(Icons.playlist_add),
                            onPressed: () {
                              _newListDialog(context);
                            },
                          ),
                        ],
                      ),
                      // decoration: BoxDecoration(color: Colors.blue),
                    ),
                    ListTile(
                      selected: (_currentIndex.home == true),
                      leading: Icon(Icons.event_note),
                      title: Text(
                        'To-Do',
                        style: (isLargeFont)
                            ? TextStyle(fontSize: 20)
                            : TextStyle(),
                      ),
                      onTap: () {
                        // changeIndex(0);
                        setState(() {
                          _screen = new MyHomePage();
                          _currentIndex = SelectedScreen(
                              home: true, settings: false, listIndex: null);
                        });
                      },
                    ),
                    //TODO: Set state to change _screen
                    Expanded(
                      child: ListView.builder(
                        //Helps build a listview builder inside a list view:
                        shrinkWrap: true,
                        itemCount: todoLists.length,
                        itemBuilder: (context, ind) {
                          return ListTile(
                            // leading: Icon(Icons.check_circle),
                            selected: _currentIndex.listIndex == ind,
                            title: Text(
                              todoLists[ind],
                              style: (isLargeFont)
                                  ? TextStyle(fontSize: 20)
                                  : TextStyle(),
                            ),
                            onTap: 
                              (){
                                changeScreen(ind);
                              },
                            
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        selected: (_currentIndex.settings == true),
                        leading: Icon(Icons.settings),
                        title: Text(
                          'Settings',
                          style: (isLargeFont)
                              ? TextStyle(fontSize: 20)
                              : TextStyle(),
                        ),
                        onTap: () {
                          setState(
                            () {
                              _screen = SettingsScreen();
                              _currentIndex = SelectedScreen(
                                  home: false, settings: true, listIndex: null);
                            },
                          );
                        },
                      ),
                    )
                  ],
                );
              }),
        ),
        body: _screen,
      ),
    );
    // );
  }
}

List<String> fakeLists() {
  return [];
}
