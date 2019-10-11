import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/auth.dart';
import 'package:flutterapp/screens/login/login_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _username;

  LoginScreenPresenter _presenter;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;

  }

  @override
  void dispose() {    
    var authStateProvider = new AuthStateProvider();
    authStateProvider.dispose(this);
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    print('----------------------------------------STATE');
    print(state);
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(context).pushReplacementNamed("/profile");

    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final ThemeData themeData = Theme.of(context);

    final screenSize = MediaQuery.of(context).size;

    var brandImage = new Container(
      child:
          new Image.asset("assets/img/edisonLogoGreen.png", width: 150.0, height: 150.0),
      margin: new EdgeInsets.only(bottom: 25.0),
    );

    var usernameField = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new TextFormField(
        onSaved: (val) => _username = val,
        validator: (val) {
          return val.length < 1 ? "Por favor, ingrese un usuario" : null;
        },
        decoration: new InputDecoration(
          labelText: "Ingrese su usuario",
          icon: new Icon(Icons.person),
          
        ),
      ),
    );

    var passwordField = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new TextFormField(
        obscureText: true,
        onSaved: (val) => _password = val,
        decoration: new InputDecoration(
            labelText: "Ingrese su contraseña",
          icon: new Icon(Icons.vpn_key)
        ),
        validator: (val) {
          return val.length < 6
              ? "La contraseña debe tener por lo menos 6 caractéres"
              : null;
        },
      ),
    );

    var loginButton = new Container(
      width: 150.0,
      child: new RaisedButton(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        textColor: themeData.cardColor,
        color: themeData.primaryColor,
        splashColor: themeData.canvasColor,
        elevation: 4.0,
        padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[new Text('Iniciar Sesión'), new Icon(Icons.directions_run, size: 16.0)],
        ),
        onPressed: () {
          _submit();
        },
      ),
    );

    var loginForm = new Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child:
            new Container(
              height: 400.0,               
              child:
            new Column(
            children: <Widget>[
              usernameField,
              passwordField,
              new Container(
                margin:
                    new EdgeInsets.symmetric(vertical: 32.0, horizontal: 0.0),
                child: _isLoading
                    ? new CircularProgressIndicator()
                    : loginButton
              )
            ],
          ),
        ),
        ),
        //loginBtn
      ],
      // crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      
      body: new Container(
          padding: new EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: ListView(children: <Widget>[brandImage, SizedBox(height: 5.0), loginForm],)
          ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(String token) async {
    setState(() => _isLoading = false);
    _sharedPreferences.setString('auth_token', token);
    String authToken = _sharedPreferences.getString('auth_token');
    print("--------------------------------------------Authtoken");
    print(authToken);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);

  }
}
