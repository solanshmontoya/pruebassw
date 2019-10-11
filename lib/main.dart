import 'package:flutter/material.dart';
import 'package:flutterapp/auth.dart';
import 'package:flutterapp/routes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return new MaterialApp(
      title: 'Edison App',
      theme: new ThemeData(
          primaryColor: Colors.indigo,
          primarySwatch: Colors.indigo,
          brightness: Brightness.light,
          fontFamily: 'assets/fonts/Poppins'),
      routes: routes,
    );
  }
}

ThemeData buildThemeData() {
  final baseTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      fontFamily: 'Poppins');
  return baseTheme.copyWith(
      buttonColor: Colors.black,
      textTheme: TextTheme().copyWith(
          button: TextStyle(fontFamily: 'Lobster', fontWeight: FontWeight.w800),
          title: TextStyle(fontFamily: 'Poppins'),
          body1: TextStyle(fontFamily: 'Poppins'),
          body2: TextStyle(fontFamily: 'Poppins'),
          subhead: TextStyle(fontFamily: 'Lobster')));
}
