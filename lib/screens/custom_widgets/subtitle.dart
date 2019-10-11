import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({
    Key key,
    this.text,
    this.background,
    this.color,
  }) : super(key: key);
  final String text;
  final Color background;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 20.0, bottom: 0.0),
      padding: new EdgeInsets.symmetric(vertical: 10.0),
      decoration: new BoxDecoration(
        color: background,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            text,
            style: new TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}