import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/screens/custom_widgets/charge_info.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/models/quote.dart';
import 'package:flutterapp/screens/quote_list/client_quotes_screen.dart';

class ChargeFail extends StatelessWidget {
  final String charge;
  final Quote quote;
  final ClientDetailModel client;
  final Credit credit;
  ChargeFail({Key key, this.charge, this.quote, this.client, this.credit}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child:new Scaffold(
          backgroundColor: Color.fromRGBO(214, 66, 53, 1.0),
          floatingActionButton: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        settings: const RouteSettings(name: '/quotes'),
                        builder: (context) => new QuotesList(
                          client: this.client,
                          credit: this.credit,
                        )));
                  },
                  child: new Text("Cuotas",
                      style: new TextStyle(color: themeData.cardColor))),
            ],
          ),
          body: new Container(
            padding: new EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Icon(
                  Icons.cancel,
                  size: 100.0,
                  color: Colors.white,
                ),
                new Container(
                    margin: new EdgeInsets.symmetric(vertical: 16.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Oh no ...",
                          style: new TextStyle(
                              color: themeData.cardColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 40.0),
                        ),
                        new Text(
                          "Ocurrió algo al realizar el cobro. Por favor, inténtelo de nuevo.",
                          style: new TextStyle(
                              color: themeData.cardColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0),
                        ),
                      ],
                    )),
                new ChargeInfo(
                    icon: Icons.person,
                    text: "${this.client.lastname}, ${this.client.name}"),
                new ChargeInfo(
                  icon: Icons.chrome_reader_mode,
                  text: this.client.dni,
                ),
                new ChargeInfo(
                  icon: Icons.monetization_on,
                  text: "S/. ${this.charge}",
                ),
              ],
            ),
          )) ,
    );

  }
}
