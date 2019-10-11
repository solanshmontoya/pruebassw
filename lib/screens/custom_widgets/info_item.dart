import "package:flutter/widgets.dart";
import "package:flutter/material.dart";

class InfoItem extends StatelessWidget {
  const InfoItem(
      {Key key,
        this.icon,
        this.primaryColor,
        this.title,
        this.text,
        this.textColor})
      : super(key: key);
  final IconData icon;
  final String title;
  final Color primaryColor;
  final String text;
  final Color textColor;
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
                  child: new Icon(icon, color: primaryColor),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: 
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(title,
                          style: new TextStyle(
                              color: primaryColor,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      new Text(
                        text,
                        maxLines: 4,
                        // overflow: TextOverflow.ellipsis,
                        //softWrap: true,
                        style: new TextStyle(color: textColor, fontSize: 15.0),
                      )
                    ],
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}