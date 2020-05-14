import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

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

  _write(String text) async {
    final file = await _getFilePath();
    await file.writeAsString(text);
  }

  Future<String> _read() async {
    String text;
    try {
      final file = await _getFilePath();

      text = await file.readAsString();

      var tasks = jsonDecode(text);

      List<TodoItem> items = [];

      for (var task in tasks) {
        print(task);

        String txt = task['text'];
        bool imp = task['important'];
        bool chek = task['checked'];

        TodoItem item = TodoItem(imp, txt, chek);
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

  listToString(List<TodoItem> todos) {
    String todosString = json.encode(todos);
    print('String: \n$todosString');

    _write(todosString);
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
      appBar: AppBar(
        actions: [
          MaterialButton(
            child: Text('Save'),
            onPressed: () {
              listToString(toDo);
            },
          ),
        ],
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 28),
        ),
      ),
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
                        });
                      },
                      child: Icon(
                        Icons.warning,
                        color: (toDo[index].important)
                            ? Colors.red[400]
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
                    },
                  ),
                  trailing: Checkbox(
                    value: toDo[index].checked,
                    onChanged: (bool value) {
                      setState(() {
                        toDo[index].checked = value;
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
          setState(() {
            toDo.add(TodoItem(false, '', false));
          });
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
  TodoItem(this.important, this.text, this.checked);

  Map<String, dynamic> toJson() => {
        'important': important,
        'text': text,
        'checked': checked,
      };
}

// class TodoList {
//   List<TodoItem> items;

//   TodoList() {
//     items = new List();
//   }

//   toJSONEncodable() {
//     return items.map((item) {
//       return item.toJson();
//     }).toList();
//   }
// }
