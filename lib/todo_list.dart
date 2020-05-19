import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:core';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> toDo = [];

  initState() {
    super.initState();
    _read();
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

      List<TodoItem> items = [];

      for (var task in tasks) {
        String txt = task['text'];
        bool imp = task['important'];
        bool chek = task['checked'];

        TodoItem item = TodoItem(important: imp, text: txt, checked: chek);
        items.add(item);
      }
      setState(() {
        toDo.addAll(items);
      });
    } catch (e) {
      print("Couldn't read file because $e");
    }
    return text;
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
    return Scaffold(
     
      body: Center(
        child: ListView.builder(
          itemCount: toDo.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(top: 20, bottom: 30),
              color: (index % 2 == 0) ? Colors.white : Color(0x22ffffff),
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
                        (toDo[index].important)
                            ? Icons.star
                            : Icons.star_border,
                        color: (toDo[index].important)
                            ? Colors.yellow[900]
                            : Colors.black45,
                      )),
                  title: TextField(
                    controller: TextEditingController(text: toDo[index].text),
                    // keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(fontSize: 20),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
          color: Colors.white,
        ),
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
