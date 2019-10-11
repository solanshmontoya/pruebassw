
class Quote {
  int _id;
  int _credit;
  String _charge_at;
  String _capital;
  String _interest;
  double _amount;
  bool _has_complete;
  double _amount_debt;
  List _fees;
  bool _is_beaten;
  String _client_name;
  int _days_late;
  double _current_arrear;
  String _completed_at;

  Quote(
      this._id,
      this._credit,
      this._charge_at,
      this._capital,
      this._interest,
      this._amount,
      this._has_complete,
      this._amount_debt,
      this._fees,
      this._is_beaten,
      this._client_name,
      this._days_late,
      this._current_arrear,
      this._completed_at
      );

  Quote.map(dynamic obj) {
    this._id = obj["id"];
    this._credit = obj["credit"];
    this._charge_at =obj["charge_at"];
    this._capital = obj["capital"];
    this._interest = obj["interest"];  
    this._has_complete = obj["has_complete"];    
    this._fees = obj["fees"];
    this._is_beaten = obj["is_beaten"];
    this._client_name = obj["client_name"];
    this._days_late = obj["days_late"];
    this._completed_at = obj["completed_at"];

    if(obj["amount"] is double){
      this._amount = obj["amount"];
    }else{
      this._amount = double.parse(obj["amount"] ?? "0");      
    }

    if(obj["amount_debt"] is double){
      this._amount_debt = obj["amount_debt"];
    }else{
      if (obj["amount_debt"] == 0) {
        this._amount_debt = 0.00;
      } else {
        this._amount_debt = double.parse(obj["amount_debt"] ?? "0");
      }
    }

    if(obj["current_arrear"] is double){
      this._current_arrear = obj["current_arrear"];
    }else{
      this._current_arrear = double.parse(obj["current_arrear"] ?? "0");
    }
  }

  int get id => _id;
  int get credit => _credit;
  String get charge_at => _charge_at;
  String get capital => _capital;
  String get interest => _interest;
  double get amount => _amount;
  bool get has_complete => _has_complete;
  double get amount_debt => _amount_debt;
  List get fees => _fees;
  bool get is_beaten => _is_beaten;
  String get client_name => _client_name;
  double get current_arrear => _current_arrear;
  int get days_late => _days_late;
  String get completed_at => _completed_at ;

  bool isCompletedBefore(){
    if(this._completed_at=="" || this._completed_at == null ){
      return false;
    }
    return DateTime.parse(this._completed_at).compareTo(DateTime.parse(this.charge_at)) == -1;

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["credit"] = _credit;
    map["charge_at"] = _charge_at;
    map["capital"] = _capital;
    map["interest"] = _interest;
    map["amount"] = _amount;
    map["has_complete"] = _has_complete;
    map["fees"] = _fees;
    map["is_beaten"] = _is_beaten;
    map["client_name"] = _client_name;
    map["current_arrear"] = _current_arrear;
    map["days_late"] = _days_late;
    return map;
  }
}
