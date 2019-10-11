import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/models/client_detail.dart';
import 'package:flutterapp/models/fee.dart';
import 'package:flutterapp/screens/client_list/client_list_screen.dart';
import 'package:flutterapp/screens/quote_detail/quote_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/screens/quote_list/client_quotes_screen_presenter.dart';
import 'package:flutterapp/models/quote.dart';
import 'package:date_format/date_format.dart';
import 'package:flutterapp/auth.dart';
import 'package:intl/intl.dart';
import 'package:flutterapp/utils/util.dart';

class QuotesList extends StatefulWidget {
  static String tag = 'quote';
  final Credit credit;
  final ClientDetailModel client;
  QuotesList({Key key, this.credit, this.client}) : super(key: key);

  @override
  _QuotesListState createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList>
    implements QuotesScreenContract {
  List<Quote> _quotes;
  bool _success;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  QuotesScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    _presenter = new QuotesScreenPresenter(this, authToken);
    _presenter.requestQuotes(widget.credit.id);
  }

  _closeSession() async {
    _sharedPreferences = await _prefs;
    _sharedPreferences.remove('auth_token');
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  _navigateToHome(){
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            settings: const RouteSettings(name: '/home'),
            builder: (context) => new SearchList(
                zone: widget.client.zone_from.toString()
            )), (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _fetchSessionAndNavigate();
  }

  @override
  void onQuotesSuccess(List<Quote> quote) {
    setState(() {
      _success = true;
      _quotes = quote;
    });
  }

  @override
  void onQuotesError(String errorTxt) {
    print(errorTxt);
  }

  List<QuoteTitle> _buildList(credit, client ) {
    return _quotes
        .map((quote) => new QuoteTitle(quote, credit, this._presenter, client))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.canvasColor,
      appBar: new AppBar(
        title: Text('Cuotas'),
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
      body: _success
          ? new ListView(children: _buildList(widget.credit, widget.client))
          : new Center(
        child:new CircularProgressIndicator(),
      )
    );
  }
}

class QuoteTitle extends StatelessWidget {
  final Quote _quote;
  final Credit _credit;
  final QuotesScreenPresenter _presenter;
  final ClientDetailModel _client;
  const QuoteTitle(this._quote, this._credit, this._presenter, this._client);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final formatter = new NumberFormat.simpleCurrency(name: 'PEN');

    _getAmounts() {
      return this._quote.fees
          .map((fee) => double.parse(fee['amount_received'])).toList();
    }
    _getArrears(){
      return this._quote.fees
          .map((fee) => double.parse(fee['arrears'])).toList();
    }

    double _sumPayed(){
      if (this._quote.fees.length > 0) {
        List<double> _amounts = _getAmounts();
        List<double> _arrears = _getArrears();
        double _sumAmounts = _amounts.reduce((a, b) => a + b);
        double _sumArrears = _arrears.reduce((a, b) => a + b);
        return _sumAmounts + _sumArrears;
      } else {
        return 0.00;
      }
    }
    double _total = this._quote.amount + this._quote.current_arrear;
    double _debt = this._quote.amount_debt + this._quote.current_arrear;
    double _payed = _sumPayed();

    Color _quoteColor;

    if (this._quote.has_complete && DateTime.parse(this._quote.charge_at) == DateTime.parse(this._quote.completed_at)) {
      _quoteColor = Colors.grey;
    } else if(this._quote.has_complete && DateTime.parse(this._quote.completed_at).isAfter(DateTime.parse(this._quote.charge_at))) {
      _quoteColor = Colors.orangeAccent;
    } else {
      if (!this._quote.has_complete && this._quote.is_beaten) {
        _quoteColor = Colors.red;
      } else if (this._quote.has_complete && !this._quote.is_beaten) {
        _quoteColor = Colors.yellow;
      } else  {
        _quoteColor = Colors.green;
      }
    }

    return new Container(
      margin: new EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 4.0),
          ),
        ],
      ),
      child: new ListTile(
        leading: new CircleAvatar(
          backgroundColor:
              _quoteColor
        ),
        title: Center(child: Text(
                  toEsp(formatDate(DateTime.parse(this._quote.charge_at), [dd, ' ', M, ', del ', yyyy ] )),
                  style: new TextStyle(fontWeight: FontWeight.bold),
              )),
        subtitle: Container(child:new Row(children: <Widget>[
          Expanded(child: Column(children:<Widget>[
            Container( child: new Text("Total"),), 
            Container( child: new Text("${formatter.format(_total)}"),),
            ],)),
          Expanded(child: Column(children:<Widget>[
            Container( child: new Text("Pagado"),), 
            Container( child: new Text(" ${formatter.format(_payed)}"),),
            ],)),
          Expanded(child: Column(children:<Widget>[
            Container( child: new Text("Debe"),), 
            Container( child: new Text(" ${formatter.format(_debt)}"),),
            ],)),
          ],
          )),
        trailing: new Icon(Icons.arrow_right),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new QuoteDetail(
                      quote: this._quote, client: this._client, credit: this._credit)));
        },
      ),
    );
  }
}
