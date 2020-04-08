class User {
  String _email;
  String _password;
  String _userName;
  String _school;
  int _points;
  bool _notifications;

  static User currentUser;

  User(this._email, this._password, this._userName, this._school, this._points,
      this._notifications);

  String get email => _email ?? 'test@test.com';

  String get userName => _userName ?? 'test';

  String get password => _password ?? 'test123';

  String get school => _school ?? 'test';

  int get points => _points ?? 0;

  bool get notifications => _notifications ?? true;

  void setNotifications(var notif) {
    _notifications = notif;
  }
}
