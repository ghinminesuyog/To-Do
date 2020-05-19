import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  _clearLocalStorage(){

  }

Future<void> _deleteDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Warning'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This will permanently delete all your to-do notes and settings.'),
              Text('Are you sure you want to delete?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Delete'),
            color: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
              _clearLocalStorage();
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
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
    return Column(
      children: <Widget>[
        // SizedBox(
        //   height: 100,
        // ),
        ListTile(
          title: Text('Dark mode: '),
          trailing: Checkbox(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                },);
              },),
        ),



        RaisedButton(
          color: Colors.red[600],
          child: Text(
            'Clear storage',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _deleteDialog,
        ),
      ],
    );
  }
}
