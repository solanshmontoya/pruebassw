import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/profile/profile_screen_presenter.dart';
import 'package:flutterapp/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = 'profile';
  ProfileScreen({
    Key key,
  }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    implements ProfileScreenContract {
  Profile _profile;
  bool _success;

  ProfileScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    print(authToken);
    _presenter = new ProfileScreenPresenter(this, authToken);
    _presenter.requestProfile();
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _fetchSessionAndNavigate();
  }

  @override
  void onProfileSuccess(Profile profile) {
    print("success");
    print(profile);
    setState(() {
      _success = true;
      _profile = profile;
    });
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        settings: const RouteSettings(name: '/home'),
        builder: (context) => new SearchList(
            zone: '${this._profile.profile["zone_debt"]}')));
  }

  @override
  void onProfileError(String errorTxt) {
    print("error detail");
    print(errorTxt);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image.asset(
            'assets/img/bgProfile.jpeg',
            fit: BoxFit.cover,
          ),
          new BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: new Container(
              color: Colors.black.withOpacity(0.1),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Bienvenido",
                      style: new TextStyle(
                          color: themeData.primaryColor,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w800)),
                  new Text("Estamos cargando tus rutas",
                      style: new TextStyle(
                          color: themeData.primaryColor, fontSize: 15.0)),
                  new Container(
                    height: 100.0,
                  ),
                  new CircularProgressIndicator()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
