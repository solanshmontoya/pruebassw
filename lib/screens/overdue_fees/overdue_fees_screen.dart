import 'package:flutter/material.dart';
import 'package:flutterapp/models/client_credit.dart';
import 'package:flutterapp/screens/client_detail/client_detail_screen.dart';
import 'dart:async';
import 'package:flutterapp/screens/overdue_fees/overdue_fees_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OverdueFeeds extends StatefulWidget {
  final String zone;
  OverdueFeeds({Key key, this.zone}) : super(key: key);
  @override
  _OverdueFeedsState createState() => _OverdueFeedsState();
}

class _OverdueFeedsState extends State<OverdueFeeds>
    implements OverdueFeesContract {
  List<Credit> _credits;
  bool _success;

  OverdueFeesScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    _presenter = new OverdueFeesScreenPresenter(this, authToken);
    _presenter.requestOverdueFees(widget.zone);
  }

  @override
  void onOverdueFeesSuccess(List<Credit> credits) {
    setState(() {
      _success = true;
      _credits = credits;
    });
  }

  @override
  void onOverdueFeesError(String errorTxt) {
    print(errorTxt);
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _fetchSessionAndNavigate();
  }

  List<OverdueFee>_buildList() {
    /*var _filterList = _credits.where((quote) => quote.is_beaten == true);*/
    return _credits.map((credit) => new OverdueFee(credit, this._presenter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      _success ?
      new ListView(
        children: _buildList(),
      ): new Center(
        child: new CircularProgressIndicator(),
      )
    );
  }
}

class OverdueFee extends StatelessWidget {
  final Credit _credit;
  final OverdueFeesScreenPresenter _presenter;
  const OverdueFee(this._credit, this._presenter);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(_credit.client["name"] + ' ' +_credit.client["lastname"] ),
      leading: new Text("${_credit.due_date}"),
      trailing: new Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                new ClientDetail(clientId: '${_credit.client["id"]}')));
      }
    );
  }
}
