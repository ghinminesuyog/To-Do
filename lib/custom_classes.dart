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

}