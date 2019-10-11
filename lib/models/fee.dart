class Fee extends Comparable<Fee>{
  int _id;
  int _quote;
  String _amount_received;
  String _arrears;
  String _created_at;
  String _owner;
  String _credit_info;
  int _credit_id;
  double _amount_received_total;

  Fee(
      this._id,
      this._quote,
      this._amount_received,
      this._arrears,
      this._created_at,
      this._owner
      );

  Fee.map(dynamic obj) {
    this._id = obj["id"];
    this._credit_info = obj["credit_info"];
    this._credit_id = obj["credit_id"];
    this._quote = obj["quote"];
    this._amount_received = obj["amount_received"];
    this._arrears = obj["arrears"];
    this._created_at = obj["created_at"];
    this._owner = obj["owner"];

    this._amount_received_total = double.parse(this._amount_received);
  }

  int get id => _id;
  int get quote => _quote;
  String get credit_info => _credit_info;
  int get credit_id => _credit_id;
  String get amount_received => _amount_received;
  String get arrears => _arrears;
  String get created_at => _created_at;
  String get owner => _owner;
  double get amount_received_total => _amount_received_total;

  @override
  int compareTo(Fee f){
    if(f.id == this._id){
      return 0;
    }
    return -1;
  }

  addToTotal(double tmp){
    _amount_received_total += tmp;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["credit_info"] = _credit_info;
    map["credit_id"] = _credit_id;
    map["quote"] = _quote;
    map["amount_received"] = _amount_received;
    map["arrears"] = _arrears;
    map["created_at"] = _created_at;
    map["owner"] = _owner;
    return map;
  }
}
