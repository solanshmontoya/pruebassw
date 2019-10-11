import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomCart extends StatelessWidget {
  const CustomCart(
      {Key key,
        this.image,
        this.height,
        this.background,
        this.icon,
        this.iconColor,
        this.name,
        this.lastname,
        this.dni})
      : super(key: key);
  final String image;
  final double height;
  final Color background;
  final IconData icon;
  final Color iconColor;
  final String name;
  final String lastname;
  final String dni;
  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 120.0,
        child: new Stack(
          children: <Widget>[
            new Container(
              height: height,
              margin: new EdgeInsets.only(left: 46.0),
              decoration: new BoxDecoration(
                color: background,
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: new Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(lastname,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0)),
                  new Text(
                    name,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Container(
                    margin: new EdgeInsets.fromLTRB(70.0, 20.0, 70.0, 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          icon,
                          color: iconColor,
                        ),
                        new Text(
                          dni,
                          style: new TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(vertical: 16.0),
              alignment: FractionalOffset.centerLeft,
              child: new Image(
                image: new AssetImage(image),
                height: 92.0,
                width: 92.0,
              ),
            )
          ],
        ));
  }
}