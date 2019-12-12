import 'themes/custom_theme.dart';
import 'themes/themes.dart';
import 'package:flutter/material.dart';

class TemasScreen extends StatefulWidget {
  @override
  _TemasScreenState createState() => _TemasScreenState();
}

class _TemasScreenState extends State<TemasScreen> {

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    _changeTheme(context, MyThemeKeys.LIGHT);
                  },
                  child: Text("Claro"),
                ),
                RaisedButton(
                  onPressed: () {
                    _changeTheme(context, MyThemeKeys.DARK);
                  },
                  child: Text("Oscuro"),
                ),
                RaisedButton(
                  onPressed: () {
                    _changeTheme(context, MyThemeKeys.DARKER);
                  },
                  child: Text("Mas Oscuro"),
                ),
              
               
              ],
            ),
          ),
        ),
    );
  }
}