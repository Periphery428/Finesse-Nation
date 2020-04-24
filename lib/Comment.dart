import 'User.dart';

class Comment {
  String _comment;
  String _emailId;
  String _postedTime;

  Comment(String comment, String emailId, String postedTime) {
    _comment = comment;
    _emailId = emailId;
    _postedTime = postedTime;
  }

  static Comment post(String comment) {
    String emailId = User.currentUser.email;
    String postedTime = DateTime.now().toString();
    return Comment(comment, emailId, postedTime);
  }

  static Comment fromJson(var json) {
    String comment = json['comment'];
    String emailId = json['emailId'];
    String postedTime = json['postedTime'];
    return Comment(comment, emailId, postedTime);
  }

  String get comment => _comment;

  String get emailId => _emailId;

  String get postedTime => _postedTime;

  DateTime get postedDateTime => DateTime.parse(_postedTime);

  Map toMap() {
    var map = Map<String, String>();
    map['comment'] = _comment;
    map['emailId'] = _emailId;
    map['postedTime'] = _postedTime;
    return map;
  }
}