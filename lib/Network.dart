import 'dart:convert';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/Pages/SettingsPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finesse_nation/.env.dart';
import 'package:finesse_nation/login/flutter_login.dart';
import 'package:finesse_nation/Comment.dart';

class Network {
  static const DOMAIN = 'https://finesse-nation.herokuapp.com/api/';
  static const DELETE_URL = DOMAIN + 'food/deleteEvent';
  static const ADD_URL = DOMAIN + 'food/addEvent';
  static const GET_URL = DOMAIN + 'food/getEvents';
  static const ADD_COMMENT_URL = DOMAIN + 'comment';
  static const GET_COMMENT_URL = DOMAIN + 'comment/';
  static const UPDATE_URL = DOMAIN + 'food/updateEvent';
  static const LOGIN_URL = DOMAIN + 'user/login';
  static const SIGNUP_URL = DOMAIN + 'user/signup';
  static const PASSWORD_RESET_URL = DOMAIN + 'user/generatePasswordResetLink';
  static const NOTIFICATION_TOGGLE_URL = DOMAIN + 'user/changeNotifications';
  static const GET_CURRENT_USER_URL = DOMAIN + 'user/getCurrentUser';
  static const SEND_NOTIFICATION_URL = 'https://fcm.googleapis.com/fcm/send';
  static const ALL_TOPIC = 'test';
  static final token = environment['FINESSE_API_TOKEN'];
  static final serverKey = environment['FINESSE_SERVER_KEY'];

  static Future<http.Response> postData(var url, var data) async {
    return await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(data));
  }

  static Future<void> addFinesse(Finesse newFinesse) async {
    Map bodyMap = newFinesse.toMap();
    http.Response response = await postData(ADD_URL, bodyMap);

    final int statusCode = response.statusCode;
    if (statusCode != 200 && statusCode != 201) {
      throw Exception(
          "Error while posting data, $token, ${response.statusCode}, ${response.body}, ${response.toString()}");
    }
  }

  static Future<List<Finesse>> fetchFinesses() async {
    final response = await http.get(GET_URL, headers: {'api_token': token});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Finesse> responseJson =
          data.map<Finesse>((json) => Finesse.fromJson(json)).toList();
      responseJson = await applyFilters(responseJson);
      return responseJson;
    } else {
      throw Exception('Failed to load finesses');
    }
  }

  static Future<List<Finesse>> applyFilters(responseJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool activeFilter = prefs.getBool('activeFilter') ?? true;
    final bool typeFilter = prefs.getBool('typeFilter') ?? true;
    List<Finesse> filteredFinesses = List<Finesse>.from(responseJson);

    if (activeFilter == false) {
      filteredFinesses.removeWhere((fin) => fin.getActive().length > 2);
      filteredFinesses.removeWhere(
          (fin) => fin.getActive().contains(User.currentUser.email));
      filteredFinesses
          .removeWhere((fin) => fin.getActive().contains(fin.emailId));
    }
    if (typeFilter == false) {
      filteredFinesses.removeWhere((value) => value.getCategory() == "Other");
    }
    return filteredFinesses;
  }

  static Future<void> removeFinesse(Finesse newFinesse) async {
    var jsonObject = {"eventId": newFinesse.getId()};
    http.Response response = await postData(DELETE_URL, jsonObject);

    if (response.statusCode != 200) {
      throw new Exception("Error while removing finesse");
    }
  }

  static Future<void> updateFinesse(Finesse newFinesse) async {
    var jsonObject = {"eventId": newFinesse.getId()};
    var bodyMap = newFinesse.toMap();
    bodyMap.addAll(jsonObject);
    http.Response response = await postData(UPDATE_URL, bodyMap);

    if (response.statusCode != 200) {
      throw new Exception("Error while updating finesse");
    }
  }

  static Future<http.Response> sendToAll(String title, String body, String id,
      {String topic: ALL_TOPIC}) {
    final content = {
      'notification': {
        'body': '$body',
        'title': '$title',
        'image': 'https://i.imgur.com/rw4rJt2.png',
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'event_id': '$id',
      },
      'to': '/topics/$topic',
    };
    return http.post(
      SEND_NOTIFICATION_URL,
      body: json.encode(content),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
    );
  }

  // Sign in callback
  static Future<String> authUser(LoginData data) async {
    Map bodyMap = data.toMap();
    http.Response response = await postData(LOGIN_URL, bodyMap);

    var status = response.statusCode;
    if (status == 400) {
      return 'Username or password is incorrect.';
    }
    await Network.updateCurrentUser(email: data.email);
    return null;
  }

  // Forgot Password callback
  static Future<String> recoverPassword(String email) async {
    email = email.trim();
    var emailCheck = validateEmail(email);
    const VALID_STATUS = null;
    if (emailCheck == VALID_STATUS) {
      var payload = {"emailId": email};
      http.Response response = await postData(PASSWORD_RESET_URL, payload);
      if (response.statusCode == 200) {
        return null;
      } else {
        return "Password Reset request failed";
      }
    } else {
      return emailCheck;
    }
  }

  // Sign up callback
  static Future<String> createUser(LoginData data) async {
    String email = data.email;
    email = email.trim();
    String password = data.password;
    var payload = {
      "emailId": email,
      "password": password,
    };
    http.Response response = await postData(SIGNUP_URL, payload);

    var status = response.statusCode, respBody = json.decode(response.body);
    if (status == 400) {
      return respBody['msg'];
    }
    await Network.updateCurrentUser(email: data.email);
    return null;
  }

  static String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email can\'t be empty';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
    if (emailValid) {
      return null;
    }

    return "Invalid email address";
  }

  static String validatePassword(String password) {
    return password.length < 6
        ? 'Password must be at least 6 characters'
        : null;
  }

  static Future<void> changeNotifications(toggle) async {
    var payload = {"emailId": User.currentUser.email, 'notifications': toggle};
    http.Response response = await postData(NOTIFICATION_TOGGLE_URL, payload);
    if (response.statusCode == 200) {
      User.currentUser.setNotifications(toggle);
    } else {
      throw Exception('Notification change request failed');
    }
  }

  static Future<void> updateCurrentUser({String email}) async {
    email = email ?? User.currentUser.email;
    var payload = {"emailId": email};
    http.Response response = await postData(GET_CURRENT_USER_URL, payload);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      User.currentUser = User.fromJson(data);
      await Notifications.notificationsSet(User.currentUser.notifications);
    } else {
      throw Exception('Failed to get current user');
    }
  }

  static Future<http.Response> addComment(
      Comment comment, String eventId) async {
    Map bodyMap = comment.toMap();
    bodyMap['eventId'] = eventId;
    http.Response response = await postData(ADD_COMMENT_URL, bodyMap);

    final int statusCode = response.statusCode;
    if (statusCode != 200) {
      throw Exception(
          "Error while adding comment, status = ${response.statusCode}, ${response.body}}");
    }
    return response;
  }

  static Future<List<Comment>> getComments(String eventId) async {
    final response = await http
        .get(GET_COMMENT_URL + eventId, headers: {'api_token': token});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Comment> comments =
          data.map<Comment>((json) => Comment.fromJson(json)).toList();
      return comments;
    } else {
      throw Exception(
          "Error while getting comments, status = ${response.statusCode}, ${response.body}}");
    }
  }
}
