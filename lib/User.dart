class User {
  String _email;
  String _password;

  static userAdd(email, password) {
    return User(email, password);
  }

  User(this._email, this._password);

  User.map(dynamic obj) {
    this._email = obj["email"];
    this._password = obj["password"];
  }

  String get username => _email;

  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["emailId"] = _email;
    map["password"] = _password;

    return map;
  }
}
