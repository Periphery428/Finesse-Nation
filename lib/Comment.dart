import 'User.dart';

class Comment {
  String _comment;
  String _emailId;
  DateTime _postedTime;

  Comment(String comment, String emailId, String postedTime) {
    _comment = comment;
    _emailId = emailId;
    _postedTime = parse(postedTime);
  }

  static Comment post(String comment) {
    String emailId = User.currentUser.email;
    String postedTime = DateTime.now().toString();
    return Comment(comment, emailId, postedTime);
  }

  factory Comment.fromJson(var json) {
    String comment = json['comment'];
    String emailId = json['emailId'];
    String postedTime = json['postedTime'];
    return Comment(comment, emailId, postedTime);
  }

  String get comment => _comment;

  String get emailId => _emailId;

  DateTime get postedTime => _postedTime;

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['comment'] = comment;
    map['emailId'] = emailId;
    map['postedTime'] = postedTime.toString();
    return map;
  }

  static dynamic parse(String time) {
    if (time != null) {
      try {
        String timeStr = time.toString();
        DateTime res = DateTime.parse(timeStr);
        return res;
      } catch (Exception) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
