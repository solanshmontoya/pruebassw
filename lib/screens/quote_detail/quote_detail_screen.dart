import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/models/fee.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';
import 'package:flutterapp/screens/custom_widgets/custom_card.dart';
import 'package:flutterapp/screens/custom_widgets/info_item.dart';
import 'package:flutterapp/models/quote.dart';
import 'package:flutterapp/screens/charge/charge_screen.dart';
import 'package:flutterapp/auth.dart';
import 'package:flutterapp/screens/custom_widgets/subtitle.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutterapp/utils/util.dart';

class QuoteDetail extends StatefulWidget {
  final Quote quote;
  final ClientDetailModel client;
  final Credit credit;
  QuoteDetail({Key key, this.quote, this.client, this.credit})
      : super(key: key);
  @override
  _QuoteDetailState createState() => _QuoteDetailState();
}

class _QuoteDetailState extends State<QuoteDetail> {
  Quote _quote;
  Credit _credit;
  String _total;
  List _fees;
  final formatter = new NumberFormat.simpleCurrency(name: 'PEN');
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _quote = widget.quote;
    _credit = widget.credit;
    _total = _calcTotal();
    _fees = _quote.fees;
  }

  String _calcTotal() {
    double total;
    total = _quote.amount_debt + _quote.current_arrear;
    return total.toString();
  }

  void _navigate() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Charge(
                quote: this._quote,
                client: widget.client,
                total: _total,
                credit: _credit)));
  }

  _closeSession() async {
    _sharedPreferences = await _prefs;
    _sharedPreferences.remove('auth_token');
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  _navigateToHome(){
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            settings: const RouteSettings(name: '/home'),
            builder: (context) => new SearchList(
                zone: widget.client.zone_from.toString()
            )), (Route<dynamic> route) => false);
  }

  List<Fees> _buildList() {
    return _fees
        .map((fee) =>
            new Fees(fee["created_at"], fee["amount_received"], fee["arrears"]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: false,
          title: new Text('Detalle de cuota'),
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
          child: new CustomScrollView(
            slivers: <Widget>[
              new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                new Container(
                  margin: new EdgeInsets.all(16.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height: 50.0,
                        width: 200.0,
                        padding: new EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: new BoxDecoration(
                          color: themeData.cardColor,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(30.0),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: new Offset(0.0, 4.0),
                            ),
                          ],
                        ),
                        child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                'Total:',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeData.primaryColorDark),
                              ),
                              new Text(
                                'S/.${double.parse(this._total).toStringAsFixed(2)}',
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0),
                              )
                            ]),
                      ),
                      new Container(
                        child: new RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          textColor: themeData.cardColor,
                          color: double.parse(this._total) > 0
                              ? themeData.primaryColor
                              : Color.fromRGBO(210, 210, 210, 1.0),
                          splashColor: themeData.canvasColor,
                          elevation: 4.0,
                          padding: new EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text('Cobrar'),
                            ],
                          ),
                          onPressed: () {
                            if (double.parse(this._total) > 0) {
                              _navigate();
                            } else {
                              return null;
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.symmetric(horizontal:50.0),
                  child: new Text("Se cobrará, primero la deuda y el sobrante a cuenta de la mora"),
                ),                
                new InfoItem(	
                  icon: Icons.monetization_on,	
                  primaryColor: Colors.indigo,	
                  title: 'Deuda',	
                  text: 'S/. ${this._quote.amount_debt}',	
                  textColor: Colors.black87,	
                ),	
                new InfoItem(	
                  icon: Icons.details,	
                  primaryColor: Colors.indigo,	
                  title: 'Mora',	
                  text: "S/. ${this._quote.current_arrear}",	
                  textColor: Colors.black87,	
                ),
                new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 24.0),
                    child: new Column(
                      children: <Widget>[
                        new Subtitle(
                          text: "Pagos Realizados",
                          background: themeData.primaryColor,
                          color: themeData.cardColor,
                        ),
                        new Container(
                            margin:
                                new EdgeInsets.only(top: 00.0, bottom: 20.0),
                            padding: new EdgeInsets.symmetric(vertical: 10.0),
                            decoration: new BoxDecoration(
                              color: themeData.cardColor,
                              shape: BoxShape.rectangle,
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: _fees.length > 0 ?
                            new Column(children: _buildList())
                                :
                                new Text("Aún no ha realizado ningún pago")
                        )
                      ],
                    ))
              ]))
            ],
          ),
        ));
  }
}

class Fees extends StatelessWidget {
  final String _date;
  final String _amount;
  final String _arrears;
  const Fees(this._date, this._amount, this._arrears);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new ListTile(
      title: Center(
          child: Text(
        toEsp(formatDate(DateTime.parse(this._date), [dd, ' ', M, ', del ', yyyy])),
        style: new TextStyle(
            fontWeight: FontWeight.bold, color: themeData.primaryColor),
      )),
      subtitle: Container(
          child: new Row(
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Container(
                child: new Text(
                  "Deuda",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: new Text("S/. ${this._amount}"),
              ),
            ],
          )),
          Expanded(
              child: Column(
            children: <Widget>[
              Container(
                child: new Text(
                  "Mora",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: new Text("S/. ${this._arrears}"),
              ),
            ],
          )),
          Expanded(
              child: Column(
            children: <Widget>[
              Container(
                child: new Text(
                  "Total",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: new Text(
                    "S/. ${double.parse(this._amount) + double.parse(this._arrears)}"),
              ),
            ],
          )),
        ],
      )),
    );
  }
}
