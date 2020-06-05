import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'custom_classes.dart';
import 'dart:core';
import 'dart:io';

_getFilePath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/my_file.txt');
}

write(List<TodoItem> toDo) async {
  final file = await _getFilePath();

  List<TodoItem> todos = toDo;

  // ToDoList defaultList = ToDoList(listName:'zyxwvu',todos: todos);
  // ToDoList defaultList3 = ToDoList(listName:'zyxwvu',todos: todos);

  readAllLists();

  Map<String, List<TodoItem>> newMap = {'zyxwvu':todos,'abcde':[TodoItem(checked: true,important: true,text: 'Hard coded')]} ;

  String todosString = json.encode(newMap);
  print(todosString);

  await file.writeAsString(todosString);
}


readAllLists() async {
  String text;
  List<TodoItem> toDo = [];
  try {
    final file = await _getFilePath();

    text = await file.readAsString();

    var tasks = jsonDecode(text);
   

    print(tasks);

    for (var task in tasks) {
      String txt = task['text'];
      bool imp = task['important'];
      bool chek = task['checked'];

      TodoItem item = TodoItem(important: imp, text: txt, checked: chek);

      toDo.add(item);
    }
  } catch (e) {
    print("Couldn't read file because $e");
  }
  // return toDo;
}

Future<List<TodoItem>> read(String listName) async {
  String text;
  List<TodoItem> toDo = [];
  try {
    final file = await _getFilePath();

    text = await file.readAsString();
    // var tasks = jsonDecode(text);

    Map<String,dynamic> lists = jsonDecode(text);
    print(lists.keys);

    List<dynamic> tasks = lists[listName];

    print(tasks);

    for (var task in tasks) {
      String txt = task['text'];
      bool imp = task['important'];
      bool chek = task['checked'];

      TodoItem item = TodoItem(important: imp, text: txt, checked: chek);

      toDo.add(item);
    }
  } catch (e) {
    print("Couldn't read file because $e");
  }
  return toDo;
}

getToDoListFilePath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/my_file.txt');
}

//Settings:

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

    return settings;
  } catch (e) {
    print('Problem reading settings. $e');
  }
}

writeSettings(isDarkMode, isLargeFont) async {
  final File file = await _getSettingsFile();

  var values = {'dark': isDarkMode, 'largeFont': isLargeFont};

  String valuesString = json.encode(values);

  file.writeAsString(valuesString);

  
}

