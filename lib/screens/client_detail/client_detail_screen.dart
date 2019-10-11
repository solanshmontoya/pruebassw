import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/screens/client_detail/client_detail_screen_presenter.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/screens/custom_widgets/info_item.dart';
import 'package:flutterapp/screens/custom_widgets/into_item_placeholder.dart';
import 'package:flutterapp/screens/credit_list/credit_list_screen.dart';
import 'package:flutterapp/auth.dart';

class ClientDetail extends StatefulWidget {
  static String tag = 'client_detail';
  final String clientId;
  ClientDetail({Key key, this.clientId}) : super(key: key);
  @override
  _ClientDetailState createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail>
    implements ClientDetailScreenContract {
  ClientDetailModel _client_detail;
  bool _success;

  ClientDetailScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    print(authToken);
    _presenter = new ClientDetailScreenPresenter(this, authToken);
    _presenter.requestClientDetails(widget.clientId);
  }

  _closeSession() async {
    _sharedPreferences = await _prefs;
    _sharedPreferences.remove('auth_token');
    String authToken = _sharedPreferences.getString('auth_token');
    print(authToken);
    print(
        '--------------------------------------------------------CLOSE SESSION');
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
                new SearchList(zone: this._client_detail.zone_from.toString())),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _fetchSessionAndNavigate();
  }

  @override
  void onClientDetailSuccess(ClientDetailModel client_detail) {
    print("success");
    print(client_detail);
    setState(() {
      _success = true;
      _client_detail = client_detail;
    });
  }

  @override
  void onClientDetailError(String errorTxt) {
    print("error detail");
    print(errorTxt);
  }

  _buildTitle() {
    if (this._success) {
      return new Container(
        width: MediaQuery.of(context).size.width * 0.55,
        child: new Text(
          this._client_detail.lastname,
          maxLines: 2,
          style: new TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      );
    } else {
      return new Container(
        width: 150.0,
        child: new LinearProgressIndicator(),
      );
    }
  }

  _buildContent(themeData) {
    return new SliverChildListDelegate(<Widget>[
      new InfoItem(
        icon: Icons.person,
        title: 'Nombre Completo',
        text: "${this._client_detail.lastname},\n${this._client_detail.name}",
        primaryColor: themeData.primaryColorDark,
        textColor: themeData.hintColor,
      ),
      new Divider(),
      new InfoItem(
        icon: Icons.contacts,
        title: 'DNI',
        text: this._client_detail.dni,
        primaryColor: themeData.primaryColorDark,
        textColor: themeData.hintColor,
      ),
      new Divider(),
      new InfoItem(
        icon: Icons.home,
        title: 'Domicilio',
        text:
            this._client_detail.address + ' - ' + this._client_detail.district,
        primaryColor: themeData.primaryColorDark,
        textColor: themeData.hintColor,
      ),
      new Divider(),
      new InfoItem(
        icon: Icons.phone_android,
        title: 'Celular',
        text: this._client_detail.cellphone != null
            ? "${this._client_detail.cellphone}"
            : 'Sin celular.',
        primaryColor: themeData.primaryColorDark,
        textColor: themeData.hintColor,
      ),
      new Divider(),
      this._client_detail.phone != null
          ? new InfoItem(
              icon: Icons.phone,
              title: 'Teléfono Fijo',
              text: "${this._client_detail.phone}",
              primaryColor: themeData.primaryColorDark,
              textColor: themeData.hintColor,
            )
          : new InfoItem(
              icon: Icons.phone,
              title: 'Teléfono Fijo',
              text: "Sin teléfono fijo.",
              primaryColor: themeData.primaryColorDark,
              textColor: themeData.hintColor,
            ),
      new Divider(),
      new InfoItem(
        icon: Icons.business,
        title: 'Dirección del Negocio',
        text: "${this._client_detail.address_of_payment}",
        primaryColor: themeData.primaryColorDark,
        textColor: themeData.hintColor,
      ),
      new Divider(),
      this._client_detail.reference != null
          ? new InfoItem(
              icon: Icons.location_on,
              title: 'Referencia',
              text: "${this._client_detail.reference}",
              primaryColor: themeData.primaryColorDark,
              textColor: themeData.hintColor,
            )
          : new InfoItem(
              icon: Icons.location_on,
              title: 'Referencia',
              text: "Sin referencia.",
              primaryColor: themeData.primaryColorDark,
              textColor: themeData.hintColor,
            ),
      new Padding(padding: new EdgeInsets.all(8.0))
    ]);
  }

  _buildPlaceholder() {
    return new SliverChildListDelegate(<Widget>[
      new PlaceholderInfoItem(
        icon: Icons.person,
        title: 'Nombre Completo',
        size: 150.0,
      ),
      new Divider(),
      new PlaceholderInfoItem(
        icon: Icons.contacts,
        title: 'DNI',
        size: 100.0,
      ),
      new Divider(),
      new PlaceholderInfoItem(
          icon: Icons.home, title: 'Domicilio', size: 120.0),
      new Divider(),
      new PlaceholderInfoItem(
          icon: Icons.phone_android, title: 'Celular', size: 110.0),
      new Divider(),
      new PlaceholderInfoItem(
          icon: Icons.phone, title: 'Teléfono Fijo', size: 100.0),
      new Divider(),
      new PlaceholderInfoItem(
        icon: Icons.business,
        title: 'Dirección del Negocio',
        size: 120.0,
      ),
      new Divider(),
      new PlaceholderInfoItem(
          icon: Icons.location_on, title: 'Referencia', size: 120.0),
      new Padding(padding: new EdgeInsets.all(8.0))
    ]);
  }

  void _navigate() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new CreditList(client: this._client_detail)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final double _heightImage = 240.0;
    return new Scaffold(
      floatingActionButton: _success
          ? new FloatingActionButton(
              onPressed: () {
                _navigate();
              },
              backgroundColor: themeData.primaryColorDark,
              child: new Icon(
                Icons.content_paste,
                semanticLabel: 'Add',
              ),
            )
          : null,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            pinned: true,
            expandedHeight: _heightImage,
            actions: _success
                ? <Widget>[
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
                  ]
                : <Widget>[
                    new IconButton(
                      icon: new Icon(Icons.directions_run),
                      onPressed: () {
                        this._closeSession();
                      },
                    ),
                  ],
            flexibleSpace: new FlexibleSpaceBar(
              title: _buildTitle(),
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new Image.asset(
                    'assets/img/bg.jpeg',
                    fit: BoxFit.cover,
                    height: _heightImage,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
              delegate:
                  _success ? _buildContent(themeData) : _buildPlaceholder())
        ],
      ),
    );
  }
}
