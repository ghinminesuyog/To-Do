import 'package:rxdart/rxdart.dart';
import 'dart:convert';

import 'package:todo/custom_classes.dart';
import 'package:todo/todolist.dart';
import 'package:flutter/material.dart';
import 'readAndWriteOperations.dart';

import 'package:todo/todolist.dart';
import 'dart:io';
import 'home_todo_list.dart';
import 'settings.dart';
class TodoItem {
  bool important;
  String text;
  bool checked;
  TodoItem({this.important, this.text, this.checked});

  Map<String, dynamic> toJson() =>
      {'important': important, 'text': text, 'checked': checked};
}

class ToDoList{
  String listName;
  List<TodoItem> todos;

  ToDoList({this.listName,this.todos});

   Map<String, dynamic> toJson() =>
      { listName: todos};

}

class SelectedScreen{
  bool home;
  bool settings;
  int listIndex;

  SelectedScreen({this.home,this.settings,this.listIndex});
}



class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool isDarkMode = false;
  bool isLargeFont = false;
  List<String> todoLists = [];
TextEditingController newListName = new TextEditingController();

  @override
  void initState() {
    super.initState();
    readSettings().then((value) {
      setState(() {
        isDarkMode = value["dark"];
        isLargeFont = value["largeFont"];
      });
    });

    getAllListNames().then((value) {
      todoLists = value;
    });
  }

  addNewList(String listName) {
    print('Created $listName');
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ToDoListPage(
        listName: listName,
      ),
    ));
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  // selected: (_currentIndex.home == true),
                  leading: Icon(Icons.event_note),
                  title: Text(
                    'To-Do',
                    style:
                        (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
                  ),
                  onTap: () {

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage()));
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    //Helps build a listview builder inside a list view:
                    shrinkWrap: true,
                    itemCount: todoLists.length,
                    itemBuilder: (context, ind) {
                      return ListTile(
                        title: Text(
                          todoLists[ind],
                          style: (isLargeFont)
                              ? TextStyle(fontSize: 20)
                              : TextStyle(),
                        ),
                        onTap: () {
                          setState(() {
                            var listNameValue = todoLists[ind];
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ToDoListPage(listName: listNameValue)));
                            print("Wanna view: $listNameValue");

                            // print("${_screen}");
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    // selected: (_currentIndex.settings == true),
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style:
                          (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
                    ),
                    onTap: () {
                      setState(
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SettingsScreen()),
                          );

                          // _currentIndex = SelectedScreen(
                          // home: false, settings: true, listIndex: null);
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}
