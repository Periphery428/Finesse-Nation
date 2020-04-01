class User {
  String _email;
  String _password;
  String _userName;

  static userAdd(email, password) {
    return User(email, password, email);
  }

  User(this._email, this._password, this._userName);


  User.map(dynamic obj) {
    this._email = obj["email"];
    this._password = obj["password"];
    this._userName = obj["username"];
  }

  String get email => _email;

  String get userName => _email;

  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["emailId"] = _email;
    map["password"] = _password;
    map["userName"] = _userName;

    return map;
  }
}
