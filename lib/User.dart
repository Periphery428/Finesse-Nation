class User {
  String _email;
  String _password;
  String _userName;
  String _school;
  int _points;
  bool _notifications;

  static User currentUser = User(null, null, null, null, 0, true);

  User(this._email, this._password, this._userName, this._school, this._points,
      this._notifications);

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      json['emailId'] ?? "",
      json['password'] ?? "",
      json['userName'] ?? "",
      json['school'] ?? "",
      json['points'] ?? 0,
      json['notifications'] ?? true,
    );

    return user;
  }
  String get email => _email ?? 'test@test.com';

  String get userName => _userName ?? 'test';

  String get password => _password ?? 'test123';

  String get school => _school ?? 'test';

  int get points => _points ?? 0;

  bool get notifications => _notifications ?? true;

  void setNotifications(var notif) {
    _notifications = notif;
  }
  void setEmail(var email) {
    _email = email;
  }
}
