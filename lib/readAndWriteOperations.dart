import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'custom_classes.dart';
import 'dart:core';
import 'dart:io';
import 'package:share/share.dart';

_getFilePath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/my_file.txt');
}

write(List<TodoItem> toDo, String listName) async {
  final file = await _getFilePath();

  List<TodoItem> todos = toDo;

  // ToDoList defaultList = ToDoList(listName:'zyxwvu',todos: todos);
  // ToDoList defaultList3 = ToDoList(listName:'zyxwvu',todos: todos);

  print('You wanna edit: $listName');

  Map<String, dynamic> original = await readAllLists();
  // Map<String, dynamic> original = Map<String, dynamic>.from(originalMap);

  // print(original);

  // print(original.keys);

  // print('Exists: $exists');

  if (original.containsKey(listName)) {
    original[listName] = todos;

    print('Changed to: $original');
    var b = original[listName];
    print('And list is: $b');
  } else {
    original[listName] = todos;
  }
  String todosString = json.encode(original);
  print(todosString);

  await file.writeAsString(todosString);

}

readAllLists() async {
  String text;
  try {
    final file = await _getFilePath();

    text = await file.readAsString();

    // print('Text $text');

    var tasks = jsonDecode(text);

    // print('Tasks: $tasks');

    return Map<String, dynamic>.from(tasks);
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

    Map<String, dynamic> lists = jsonDecode(text);
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

getAllListNames() async {
  Map<String, dynamic> map = await readAllLists();
  print(map.keys);
  List<String> x = [];
  map.forEach((key, value) {
    key.toString();
    x.add(key.toString());
  });

  x.remove('zyxwvu');

  print('Yo: $x');
  return x;
}

String convertToSharableString(List<TodoItem> list) {
  List<String> items = [];

  list.forEach((element) {
    items.add(element.text);
  });

  return items.join('\n');
}

shareToDoList(String text, String subject) {
  // final RenderBox box = context.findRenderObject();
  Share.share(text, subject: subject
      // sharePositionOrigin:
      );
}
