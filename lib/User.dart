class User {
  String _email;
  String _password;
  String _userName;
  String _school;
  int _points;

  static User currentUser;

  User(this._email, this._password, this._userName, this._school, this._points);

  String get email => _email;

  String get userName => _userName;

  String get password => _password;

  String get school => _school;

  int get points => _points;
}
