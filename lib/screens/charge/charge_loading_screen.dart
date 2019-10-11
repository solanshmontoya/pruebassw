import 'package:flutter/material.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/models/quote.dart';
import 'package:flutterapp/screens/custom_widgets/charge_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/screens/charge/charge_loading_screen_presenter.dart';
import 'package:flutterapp/screens/charge/charge_success_screen.dart';
import 'package:flutterapp/screens/charge/charge_fail_screen.dart';
import 'dart:async';

class ChargeLoading extends StatefulWidget {
  static String tag = 'charge';
  final Quote quote;
  final ClientDetailModel client;
  final dynamic charge;
  final dynamic arrear;
  final dynamic totalCharge;
  final Credit credit;
  ChargeLoading({Key key, this.quote, this.client, this.charge, this.arrear, this.totalCharge, this.credit})
      : super(key: key);
  @override
  _ChargeLoadingState createState() => _ChargeLoadingState();
}

class _ChargeLoadingState extends State<ChargeLoading>
    implements ChargeScreenContract {

  bool _success;
  ChargeScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    print(authToken);
    _presenter = new ChargeScreenPresenter(this, authToken);
    _presenter.requestCharge(widget.charge, widget.quote.id, widget.arrear);
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _fetchSessionAndNavigate();
  }

  @override
  void onChargeSuccess(Map charge) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        settings: const RouteSettings(name: '/chargeSuccess'),
        builder: (context) => new ChargeSuccess(
          charge: double.parse(widget.totalCharge).toString(),
          quote: widget.quote,
          client: widget.client,
          credit: widget.credit,
        )));
  }

  @override
  void onChargeError(String errorTxt) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        settings: const RouteSettings(name: '/chargeFail'),
        builder: (context) => new ChargeFail(
            charge: double.parse(widget.totalCharge).toString(),
            quote: widget.quote,
            client: widget.client,
            credit: widget.credit,
        )));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Scaffold(
        backgroundColor: Color.fromRGBO(247, 170, 56, 1.0),
        floatingActionButton: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation(Colors.white),
            )
          ],
        ),
        body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Icon(
                Icons.cloud_upload,
                size: 100.0,
                color: Colors.white,
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(vertical: 16.0),
                  child: new Text(
                    "Cobrando ...",
                    style: new TextStyle(
                        color: themeData.cardColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 40.0),
                  )),
              new ChargeInfo(
                  icon: Icons.person,
                  text: '${widget.client.lastname} , ${widget.client.name} '),
              new ChargeInfo(
                icon: Icons.chrome_reader_mode,
                text: widget.client.dni,
              ),
              new ChargeInfo(
                icon: Icons.monetization_on,
                text: "S/. ${widget.totalCharge}",
              ),
            ],
          ),
        ));
  }
}
