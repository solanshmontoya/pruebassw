class ClientDetailModel {
  int _id;
  String _name;
  String _lastname;
  String _dni;
  String _address;
  int _cellphone;
  String _phone;
  String _address_of_payment;
  String _reference;
  int _zone_from;
  String _district;

  ClientDetailModel(this._id, this._name, this._lastname, this._dni, this._address,
      this._cellphone, this._phone, this._address_of_payment, this._reference, this._zone_from, this._district);

  int get id => _id;
  String get name => _name;
  String get lastname => _lastname;
  String get dni => _dni;
  String get address => _address;
  int get cellphone => _cellphone;
  String get phone => _phone;
  String get address_of_payment => _address_of_payment;
  String get reference => _reference;
  int get zone_from => _zone_from;
  String get district => _district;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["lastname"] = _lastname;
    map["dni"] = _dni;
    map["address"] = _address;
    map["cellphone"] = _cellphone;
    map["phone"] = _phone;
    map["address_of_payment"] = _address_of_payment;
    map["reference"] = _reference;
    map["zone_from"] = _zone_from;
    map["district"] = _district;
    return map;
  }
}
