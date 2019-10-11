class Profile {
  String _username;
  String _email;
  String _first_name;
  String _last_name;
  Map _profile;

  Profile(
      this._username,
      this._email,
      this._first_name,
      this._last_name,
      this._profile
      );

  String get username => _username;
  String get email => _email;
  String get first_name => _first_name;
  String get last_name => _last_name;
  Map get profile => _profile;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["email"] = _email;
    map["first_name"] = _first_name;
    map["last_name"] = _last_name;
    map["profile"] = _profile;
    return map;
  }
}
