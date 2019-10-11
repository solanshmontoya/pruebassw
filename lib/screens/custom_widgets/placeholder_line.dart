import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaceholderLine extends StatelessWidget {
  const PlaceholderLine({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new LinearProgressIndicator(
      backgroundColor: Color.fromRGBO(237, 237, 237, 1.0),
      valueColor: new AlwaysStoppedAnimation(Color.fromRGBO(221, 221, 221, 1.0)),
    );
  }
}
