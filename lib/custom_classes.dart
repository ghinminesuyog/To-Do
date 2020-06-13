import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
// import 'dart:convert';

// import 'package:todo/custom_classes.dart';
import 'package:todo/todolist.dart';
import 'package:flutter/material.dart';
import 'readAndWriteOperations.dart';

// import 'package:todo/todolist.dart';
// import 'dart:io';
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

class ToDoList {
  String listName;
  List<TodoItem> todos;

  ToDoList({this.listName, this.todos});

  Map<String, dynamic> toJson() => {listName: todos};
}

class SelectedScreen {
  bool home;
  bool settings;
  int listIndex;

  SelectedScreen({this.home, this.settings, this.listIndex});
}

class MyAppDrawer extends StatefulWidget {
  @override
  _MyAppDrawerState createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {
  bool isDarkMode = false;
  bool isLargeFont = false;
  List<String> todoLists = [];
  TextEditingController newListName = new TextEditingController();

  @override
  void initState() {
    super.initState();
    readSettings().then((value) {
      if (value != null) {
        setState(() {
          isDarkMode = value["dark"];
          isLargeFont = value["largeFont"];
        });
      }
    });

    getAllListNames().then((value) {
      if (value != null) {
        print('We have $value');
        setState(() {
          todoLists = value;
        });
      }
    });
  }

  addNewList(String listName) {
    print('Created $listName');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ToDoListPage(
          listName: listName,
        ),
      ),
    );
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
                if(newListName.text != ''){
                addNewList(newListName.text);

                }else{
                  print('empty');
                }
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
                            : TextStyle(fontSize: 20),
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
                  selected: (currentIndex.home == true),
                  leading: Icon(Icons.home),
                  title: Text(
                    'Home',
                    style:
                        (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
                  ),
                  onTap: () {
                    setState(() {
                      currentIndex = SelectedScreen(
                          home: true, settings: false, listIndex: null);
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage()));
                  },
                ),
                Expanded(
                  child: 
                  // Scrollbar(
                    // isAlwaysShown: true,
                    // child: 
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 0.2,
                          ),
                        ),
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        //Helps build a listview builder inside a list view:
                        shrinkWrap: true,
                        itemCount: todoLists.length,
                        itemBuilder: (context, ind) {
                          return ListTile(
                            selected: (currentIndex.home == false &&
                                currentIndex.settings == false &&
                                currentIndex.listIndex == ind),
                            leading: Icon(Icons.event_note),
                            title: Text(
                              todoLists[ind],
                              style: (isLargeFont)
                                  ? TextStyle(fontSize: 20)
                                  : TextStyle(),
                            ),
                            onTap: () {
                              setState(() {
                                currentIndex = SelectedScreen(
                                    home: false,
                                    settings: false,
                                    listIndex: ind);
                                var listNameValue = todoLists[ind];
                                Navigator.pop(context);

                                // Navigator.pushNamed(context, listNameValue);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ToDoListPage(
                                          listName: listNameValue,
                                        )));
                                print("Wanna view: $listNameValue");

                                // print("${_screen}");
                              });
                            },
                          );
                        },
                      ),
                    ),
                  // ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 0.2,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    selected: (currentIndex.settings == true),
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style:
                          (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
                    ),
                    onTap: () {
                      setState(
                        () {
                          currentIndex = SelectedScreen(
                              home: false, settings: true, listIndex: null);
                          print(currentIndex.settings);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SettingsScreen()));
                          // Navigator.pushNamed(context, 'settings');
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

var routeCreation = new BehaviorSubject<String>();

final universalDrawer = MyAppDrawer();

SelectedScreen currentIndex =
    SelectedScreen(home: true, settings: false, listIndex: null);
