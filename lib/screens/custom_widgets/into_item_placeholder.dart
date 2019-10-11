import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/screens/custom_widgets/placeholder_line.dart';

class PlaceholderInfoItem extends StatelessWidget {
  const PlaceholderInfoItem(
      {Key key,
        this.icon,
        this.title,
        this.size
      })
      : super(key: key);
  final IconData icon;
  final String title;
  final double size;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      child: new Row(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  width: 72.0,
                  child: new Icon(icon, color: themeData.primaryColorDark),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(title,
                        style: new TextStyle(
                            color: themeData.primaryColorDark,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins')),
                    new Container(
                      width: size,
                      child: new PlaceholderLine(),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}