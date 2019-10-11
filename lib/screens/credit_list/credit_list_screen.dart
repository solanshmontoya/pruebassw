import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';
import 'package:flutterapp/screens/credit_detail/credit_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/screens/credit_list/credit_list_screen_presenter.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/auth.dart';

class CreditList extends StatefulWidget {
  static String tag = 'client_credits';
  final ClientDetailModel client;
  CreditList({Key key, this.client}) : super(key: key);
  @override
  _CreditListState createState() => _CreditListState();
}

class _CreditListState extends State<CreditList>
    implements CreditListScreenContract {
  List<Credit> _credits;
  bool _success;

  CreditListScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    _presenter = new CreditListScreenPresenter(this, authToken);
    _presenter.requestCreditList(widget.client.id);
  }

  _closeSession() async {
    _sharedPreferences = await _prefs;
    _sharedPreferences.remove('auth_token');
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            settings: const RouteSettings(name: '/home'),
            builder: (context) =>
                new SearchList(zone: widget.client.zone_from.toString())),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _fetchSessionAndNavigate();
  }

  @override
  void onClientCreditsSuccess(List<Credit> client_credits) {
    setState(() {
      _success = true;
      _credits = client_credits;
    });
  }

  @override
  void onClientCreditsError(String errorTxt) {
    print("error detail");
    print(errorTxt);
  }

  List<ListItem> _buildList() {
    return _credits
        .map((credit) => new ListItem(widget.client, credit, this._presenter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final double _heightCard = 124.0;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Estado de Cuenta'),
        centerTitle: false,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.home),
            onPressed: () {
              this._navigateToHome();
            },
          ),
          new IconButton(
            icon: new Icon(Icons.directions_run),
            onPressed: () {
              this._closeSession();
            },
          ),
        ],
      ),
      body: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: new Column(
            children: <Widget>[
              new ProfileCard(
                image: 'assets/img/profile.png',
                height: _heightCard,
                background: themeData.cardColor,
                icon: Icons.chrome_reader_mode,
                name: widget.client.name,
                lastname: widget.client.lastname + ',',
                dni: widget.client.dni,
              ),
              new Subtitle(
                text: "Estado de cuenta",
                background: themeData.primaryColor,
                color: themeData.cardColor,
              ),
              new Container(
                  decoration: new BoxDecoration(
                color: themeData.cardColor,
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
              )),
              _success
                  ? new Expanded(child: new ListView(children: _buildList()))
                  : new CircularProgressIndicator(),
            ],
          )),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard(
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

class ListItem extends StatelessWidget {
  final Credit _credit;
  final ClientDetailModel _client;
  final CreditListScreenPresenter _presenter;
  const ListItem(this._client, this._credit, this._presenter);

  @override
  Widget build(BuildContext context) {
    String _creditName;
    switch (this._credit.frequency) {
      case "D":
        {
          _creditName = "Diario";
        }
        break;
      case "P":
        {
          _creditName = "Paralelo";
        }
        break;
      case "S":
        {
          _creditName = "Semanal";
        }
        break;
      case "Q":
        {
          _creditName = "Quincenal";
        }
        break;
      case "M":
        {
          _creditName = "Mensual";
        }
        break;

      case "M-I":
        {
          _creditName = 'Crédito Mensual - Interes';
        }
        break;
      case "P-F":
        {
          _creditName = 'Crédito Mensual - Plazo Fijo';
        }
        break;
    }
    return new ListTile(
        title: new Text('Crédito ${_creditName} - ${this._credit.deliver_at}'),
        trailing: const Icon(Icons.arrow_right),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new ClientCreditDetail(
                        credit: this._credit,
                        client: this._client,
                      )));
        });
  }
}
