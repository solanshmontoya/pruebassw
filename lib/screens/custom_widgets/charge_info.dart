import "package:flutter/widgets.dart";
import "package:flutter/material.dart";

class ChargeInfo extends StatelessWidget {
  const ChargeInfo({Key key, this.icon, this.text}) : super(key: key);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new ListTile(
      leading: new Icon(this.icon, color: themeData.cardColor,),
      title: new Text(this.text, style: new TextStyle(
        color: themeData.cardColor,
        fontWeight: FontWeight.w300,
      )),
    );
  }
}
