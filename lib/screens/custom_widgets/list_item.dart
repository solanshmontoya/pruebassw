import "package:flutter/widgets.dart";
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key key,
        this.text,
      })
      : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(text),
        trailing: const Icon(Icons.arrow_right),
        onTap: () {
          Navigator.of(context).pushNamed('/quotes');
        }
    );
  }
}