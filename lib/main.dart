import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main() => runApp(MyApp());

var myTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  fontFamily: 'DancingScript',
  primaryTextTheme: TextTheme(
    headline: TextStyle(color: Colors.white),
    display1: TextStyle(color: Colors.white),
    display2: TextStyle(color: Colors.white),
    display3: TextStyle(color: Colors.white),
    display4: TextStyle(color: Colors.white),
    title: TextStyle(color: Colors.white),
    subtitle: TextStyle(color: Colors.white),
    subhead: TextStyle(color: Colors.white),
    body1: TextStyle(color: Colors.white),
    body2: TextStyle(color: Colors.white),
    caption: TextStyle(color: Colors.white),
    overline: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white),
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Dismiss keyboard when tapped elsewhere:
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'To Do',
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        home: MyHomePage(title: 'To Do'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];

  initState() {
    super.initState();

    tasks = [
      // Task(true, 'A', true),
      // Task(false, 'B', false),
      // Task(false, 'C', false),
      // Task(false, 'D', true),
      // Task(true, 'E', true),
      // Task(true, 'F', false),
      // Task(true, 'Z', true),
      // Task(false, 'Y', false),
      // Task(false, 'X', false),
      // Task(false, 'W', true),
      // Task(true, 'V', true),
      // Task(true, 'U', false)
    ];
  }

  // void saveNote() {

  // }

  delete(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  undoDelete(int index, Task item) {
    setState(() {
      tasks.insert(index, item);
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
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(top: 20, bottom: 30),
              color: (index % 2 == 0) ? Colors.white : Color(0x22ffffff),
              child: Dismissible(
                key: ObjectKey(tasks[index]),
                background: stackBehindDismiss(),
                onDismissed: (DismissDirection direction) {
                  var item = tasks[index];
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
                          tasks[index].important = !tasks[index].important;
                        });
                      },
                      child: Icon(
                        Icons.warning,
                        color: (tasks[index].important)
                            ? Colors.red[400]
                            : Colors.black45,
                      )),
                  title: TextField(
                    controller: TextEditingController(text: tasks[index].text),
                    // keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(fontSize: 20),
                    onChanged: (String val) {
                      tasks[index].text = val;
                    },
                  ),
                  trailing: Checkbox(
                    value: tasks[index].checked,
                    onChanged: (bool value) {
                      setState(() {
                        tasks[index].checked = value;
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
            tasks.add(Task(false, '', false));
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

class Task {
  bool important;
  String text;
  bool checked;
  Task(this.important, this.text, this.checked);
}