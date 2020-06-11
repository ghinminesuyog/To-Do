import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:todo/main.dart';
import 'readAndWriteOperations.dart';
import 'custom_classes.dart';

class SettingsScreen extends StatefulWidget {
  final bool setIsDarkMode;
  final bool setIsLargeFont;

  const SettingsScreen({Key key, this.setIsDarkMode, this.setIsLargeFont})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isLargeFont = false;

  initState() {
    super.initState();
    readSettings().then(
      (value) => setState(
        () {
          isDarkMode = value['dark'];
          isLargeFont = value['largeFont'];
        },
      ),
    );
    getFontSize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _clearLocalStorage() async {
    try {
      final File file = await getToDoListFilePath();
      file.delete();
    } catch (e) {
      print('Error deleting local data storage');
    }
  }

  getFontSize() {
    font.stream.listen(
      (data) {
        setState(
          () {
            isLargeFont = data;
          },
        );
      },
    );
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
                Text(
                    'This will permanently delete all your to-dos and settings.'),
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
    return Scaffold(
      drawer: MyAppDrawer(),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: isLargeFont ? TextStyle(fontSize: 28) : TextStyle(),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // SizedBox(
            //   height: 100,
            // ),
            ListTile(
              title: Text(
                'Dark mode: ',
                style: (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
              ),
              trailing: Checkbox(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    theme.add(value);
                  });
                  writeSettings(isDarkMode, isLargeFont);
                },
              ),
            ),
            ListTile(
              title: Text(
                'Large font: ',
                style: (isLargeFont) ? TextStyle(fontSize: 20) : TextStyle(),
              ),
              trailing: Checkbox(
                value: isLargeFont,
                onChanged: (value) {
                  setState(
                    () {
                      isLargeFont = value;
                      writeSettings(isDarkMode, isLargeFont);
                      font.add(value);
                    },
                  );
                },
              ),
            ),
            RaisedButton(
              color: Colors.red[600],
              child: Text(
                'Clear storage',
                style: (isLargeFont)
                    ? TextStyle(fontSize: 20, color: Colors.white)
                    : TextStyle(color: Colors.white),
              ),
              onPressed: _deleteDialog,
            ),
          ],
        ),
      ),
    );
  }
}

final theme = new BehaviorSubject<bool>();
final font = new BehaviorSubject<bool>();
