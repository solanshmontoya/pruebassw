import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/fee.dart';
import 'package:flutterapp/screens/total_charge/total_charge_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TotalCharge extends StatefulWidget {
  final String zone;
  TotalCharge({Key key, this.zone}) : super(key: key);
  @override
  _TotalChargeState createState() => _TotalChargeState();
}

class _TotalChargeState extends State<TotalCharge>
    implements FeesScreenContract {
  List<Fee> _fees;
  bool _success;
  String _date;
  dynamic _sum;
  FeesScreenPresenter _presenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate(date) async {
    print(widget.zone);
    _sharedPreferences = await _prefs;
    String authToken = _sharedPreferences.getString('auth_token');
    _presenter = new FeesScreenPresenter(this, authToken);
    _presenter.requestFees(date, widget.zone);
  }

  @override
  void initState() {
    super.initState();
    _success = false;
    _date = new DateTime.now().toString().substring(0, 10);
    _fetchSessionAndNavigate(_date);
  }

  _sumAmount(){
    var tem = 0.00;
    for (var x = 0; x < _fees.length; x++) {
      tem += double.parse(_fees[x].amount_received);
      setState(() {
        _sum = tem;
      });
    }
  }

  @override
  void onFeesSuccess(List<Fee> fee) {
    
    List<Fee> tmpFees = [];
    for(var i = 0; i < fee.length; i++){
      int k = -1 ;
      for(int j = 0; j < tmpFees.length; j++){
        print(tmpFees[j].credit_id);
        print(fee[i].credit_id);
        print('-...................');
         if(tmpFees[j].credit_id == fee[i].credit_id){
          k = j;
          break;
        }
      }
      
      if(k == -1){
        tmpFees.add(fee[i]);
      }else{
        tmpFees[k].addToTotal(fee[i].amount_received_total);
      }
    }

    setState(() {
      _success = true;  
      _fees = tmpFees;
    });
    _sumAmount();
  }

  @override
  void onFeesError(String errorTxt) {
    print(errorTxt);
  }

  List<ChargeItem>_buildList() {
      return _fees.map((fee) => new ChargeItem(fee, this._presenter)).toList();
  }



  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return
        new Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: _success ? new Text("Al ${_date}: S/. ${_sum} ") : new LinearProgressIndicator(),
            centerTitle: true,
            titleSpacing: 10.0,
          ),
         body: new Container(
        padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child:
        _success
            ? new ListView(
            children:
              _buildList(),
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ))
        );
      /*new Container(
        padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child:
        _success
            ? new ListView(
            children:
              _buildList(),
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ));*/
  }
}

class ChargeItem extends StatelessWidget {
  final Fee _fee;
  final FeesScreenPresenter _presenter;
  const ChargeItem(this._fee, this._presenter);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Text(this._fee.owner + "-" + this._fee.credit_info),
        trailing: new Text("S/. ${this._fee.amount_received_total}")
      );
  }
}
