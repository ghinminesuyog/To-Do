import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo/main.dart';
import 'dart:core';
import 'settings.dart';
import 'custom_classes.dart';
import 'readAndWriteOperations.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> toDo = [];

  bool isFiltered = false;
  TextEditingController searchTextController = new TextEditingController();
  String searchText = '';

  bool isDarkMode = false;
  bool isLargeFont = false;
  bool showSearchBar = false;

  initState() {
    super.initState();
    read('zyxwvu').then(
      (value) => setState(() {
        toDo = value;
      }),
    );
    readSettings().then((value) {
      setState(() {
        isDarkMode = value["dark"];
        isLargeFont = value["largeFont"];
      });
    });
    // getFont();
    // getTheme();

    searchTextController.addListener(() {
      setState(() {
        searchText = searchTextController.text;
      });
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  delete(int index) {
    setState(() {
      toDo.removeAt(index);
    });
    write(toDo, 'zyxwvu');
  }

  undoDelete(int index, TodoItem item) {
    setState(() {
      toDo.insert(index, item);
    });
    write(toDo, 'zyxwvu');
  }

  getFont() {
    font.stream.listen((data) {
      setState(() {
        isLargeFont = data;
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

  filterByImportance() {
    if (!isFiltered) {
      setState(
        () {
          toDo.sort(
            (b, a) => (a.important.toString().compareTo(
                  b.important.toString(),
                )),
          );

          isFiltered = true;
        },
      );
    } else {
      read('zyxwvu').then((value) {
        setState(() {
          toDo = value;
        });
      });
      isFiltered = false;
    }
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    searchList() {
      return ListView.builder(
        itemCount: toDo.length,
        itemBuilder: (context, index) {
          return (toDo[index].text.contains(searchText))
              ? ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        toDo[index].important = !toDo[index].important;
                        write(toDo, 'zyxwvu');
                      });
                    },
                    child: Icon(
                      (toDo[index].important) ? Icons.star : Icons.star_border,
                      color: (isLargeFont)
                          ? (toDo[index].important)
                              ? Colors.yellow[900]
                              : Colors.white
                          : ((toDo[index].important)
                              ? Colors.yellow[900]
                              : Colors.black45),
                    ),
                  ),
                  title: TextField(
                    controller: TextEditingController(text: toDo[index].text),
                    // keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style:
                        (isLargeFont) ? TextStyle(fontSize: 26) : TextStyle(),
                    onChanged: (String val) {
                      toDo[index].text = val;
                      write(toDo, 'zyxwvu');
                    },
                  ),
                  trailing: Checkbox(
                    value: toDo[index].checked,
                    onChanged: (bool value) {
                      setState(() {
                        toDo[index].checked = value;
                        write(toDo, 'zyxwvu');
                      });
                    },
                  ),
                )
              : (Text(''));
        },
      );
    }

    var toDoList = ListView.builder(
      itemCount: toDo.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(top: 20, bottom: 30),
          color: (index % 2 == 0)
              ? (isDarkMode ? Color(0x00000000) : Color(0xffffffff))
              : (isDarkMode ? Color(0x22000000) : Color(0x00ffffff)),
          child: Dismissible(
            key: ObjectKey(toDo[index]),
            background: stackBehindDismiss(),
            onDismissed: (DismissDirection direction) {
              var item = toDo[index];
              delete(index);
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Task deleted"),
                  duration: Duration(seconds: 10),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      //To undo deletion
                      undoDelete(index, item);
                    },
                  ),
                ),
              );
            },
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  setState(() {
                    toDo[index].important = !toDo[index].important;
                    write(toDo, 'zyxwvu');
                  });
                },
                child: Icon(
                  (toDo[index].important) ? Icons.star : Icons.star_border,
                  color: (toDo[index].important)
                      ? Colors.yellow[900]
                      : isDarkMode ? Colors.white : Colors.black45,
                ),
              ),
              title: TextField(
                controller: TextEditingController(text: toDo[index].text),
                // keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                style: (isLargeFont) ? TextStyle(fontSize: 25) : TextStyle(),
                onChanged: (String val) {
                  toDo[index].text = val;
                  write(toDo, 'zyxwvu');
                },
              ),
              trailing: Checkbox(
                value: toDo[index].checked,
                onChanged: (bool value) {
                  setState(() {
                    toDo[index].checked = value;
                    write(toDo, 'zyxwvu');
                  });
                },
              ),
            ),
          ),
        );
      },
    );

    var addNewButton = FloatingActionButton(
      onPressed: () {
        setState(
          () {
            toDo.insert(
              0,
              TodoItem(
                checked: false,
                text: '',
                important: false,
              ),
            );
          },
        );
      },
      tooltip: 'Create a new task',
      child: Icon(
        Icons.add,
        // color: Colors.white,
      ),
    );

    return Scaffold(
      drawer: universalDrawer,
      appBar: AppBar(
        title: showSearchBar
            ? TextField(
                controller: searchTextController,
                onChanged: (value) {},
              )
            : Text(
                'To Do',
                style: isLargeFont ? TextStyle(fontSize: 28) : TextStyle(),
              ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
              });
            },
            icon: Icon(Icons.search),
            tooltip: 'Search',
          ),
          IconButton(
            onPressed: filterByImportance,
            icon: Icon(Icons.filter_list),
            tooltip: 'Filter by importance',
          ),
        ],
      ),
      floatingActionButton: addNewButton,
      body: Center(
        child: (showSearchBar) ? searchList() : toDoList,
      ),
    );
  }
}
