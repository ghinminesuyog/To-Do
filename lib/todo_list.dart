import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'settings.dart';

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

  initState() {
    super.initState();
    _read();
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

  _getFilePath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/my_file.txt');
  }

  _write() async {
    final file = await _getFilePath();

    List<TodoItem> todos = toDo;
    String todosString = json.encode(todos);

    await file.writeAsString(todosString);
  }

  Future<String> _read() async {
    String text;
    try {
      final file = await _getFilePath();

      text = await file.readAsString();

      var tasks = jsonDecode(text);

      setState(() {
        toDo.clear();
      });

      for (var task in tasks) {
        String txt = task['text'];
        bool imp = task['important'];
        bool chek = task['checked'];

        TodoItem item = TodoItem(important: imp, text: txt, checked: chek);
        setState(() {
          toDo.add(item);
        });
      }
    } catch (e) {
      print("Couldn't read file because $e");
    }
    return text;
  }

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
        isLargeFont = settings['largeFont'];
        isDarkMode = settings['dark'];
      });
    } catch (e) {
      print('Problem reading settings. $e');
    }
  }

  delete(int index) {
    setState(() {
      toDo.removeAt(index);
    });
  }

  undoDelete(int index, TodoItem item) {
    setState(() {
      toDo.insert(index, item);
    });
  }
getFont() {
    font.stream.listen((data) {
      setState(() {
        isLargeFont = data;
      });
    });
    return isLargeFont;
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
      _read();
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
                        _write();
                      });
                    },
                    child: Icon(
                      (toDo[index].important) ? Icons.star : Icons.star_border,
                       color: (isDarkMode)
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
                    style: (getFont()) ? TextStyle(fontSize: 20) : TextStyle(),
                    onChanged: (String val) {
                      toDo[index].text = val;
                      _write();
                    },
                  ),
                  trailing: Checkbox(
                    value: toDo[index].checked,
                    onChanged: (bool value) {
                      setState(() {
                        toDo[index].checked = value;
                        _write();
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
           color: (!isDarkMode)
              ? ((index % 2 == 0) ? Color(0x00000000) : Color(0x22000000))
              : ((index % 2 == 0) ? Colors.white : Color(0x22ffffff)),
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
                    _write();
                  });
                },
                child: Icon(
                  (toDo[index].important) ? Icons.star : Icons.star_border,
                  color: (toDo[index].important)
                      ? Colors.yellow[900]
                      : Colors.black45,
                ),
              ),
              title: TextField(
                controller: TextEditingController(text: toDo[index].text),
                // keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                style: getFont() ? TextStyle(fontSize: 20) : TextStyle(),
                onChanged: (String val) {
                  toDo[index].text = val;
                  _write();
                },
              ),
              trailing: Checkbox(
                value: toDo[index].checked,
                onChanged: (bool value) {
                  setState(() {
                    toDo[index].checked = value;
                    _write();
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
      appBar: AppBar(
        title: TextField(
          controller: searchTextController,
          onChanged: (value) {},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: filterByImportance,
            icon: Icon(Icons.filter_list),
            tooltip: 'Filter by importance',
          ),
        ],
      ),
      floatingActionButton: addNewButton,
      body: Center(
        child: ((searchText == '' || searchText == null)
            ? toDoList
            : searchList()),
      ),
    );
  }
}

class TodoItem {
  bool important;
  String text;
  bool checked;
  TodoItem({this.important, this.text, this.checked});

  Map<String, dynamic> toJson() =>
      {'important': important, 'text': text, 'checked': checked};
}
