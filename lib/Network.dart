import 'dart:convert';

import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/User.dart';
import 'package:http/http.dart' as http;
import '.env.dart';
//import 'package:flutter_login/flutter_login.dart';
import 'login/flutter_login.dart';

class Network {
  static const DOMAIN = 'https://finesse-nation.herokuapp.com/api/';
  static const DELETE_URL = DOMAIN + 'food/deleteEvent';
  static const ADD_URL = DOMAIN + 'food/addEvent';
  static const GET_URL = DOMAIN + 'food/getEvents';
  static const UPDATE_URL = DOMAIN + 'food/updateEvent';
  static const LOGIN_URL = DOMAIN + 'user/login';
  static const SIGNUP_URL = DOMAIN + 'user/signup';
  static const PASSWORD_RESET_URL = DOMAIN + 'user/generatePasswordResetLink';

  static final token = environment['FINESSE_API_TOKEN'];

  static Future<void> addFinesse(Finesse newFinesse) async {
    Map bodyMap = newFinesse.toMap();
    final http.Response response = await http.post(ADD_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(bodyMap));

    final int statusCode = response.statusCode;
    if (statusCode != 200 && statusCode != 201) {
      throw new Exception(
          "Error while posting data, $token, ${response.statusCode}, ${response.body}, ${response.toString()}");
    }
  }

  static Future<List<Finesse>> fetchFinesses() async {
    final response = await http.get(GET_URL, headers: {'api_token': token});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var responseJson =
          data.map<Finesse>((json) => Finesse.fromJson(json)).toList();
      return responseJson;
    } else {
      print('nope');
      print(token);
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load finesses');
    }
  }

  static Future<void> removeFinesse(Finesse newFinesse) async {
    var jsonObject = {"eventId": newFinesse.getId()};
    final http.Response response = await http.post(DELETE_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(jsonObject));

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while removing finesses");
    }
    if (response.statusCode == 201) {
      // TODO
    }
  }

  static Future<void> updateFinesse(Finesse newFinesse) async {
    var jsonObject = {"eventId": newFinesse.getId()};
    var bodyMap = newFinesse.toMap();
    bodyMap.addAll(jsonObject);
    final http.Response response = await http.post(UPDATE_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(bodyMap));

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while removing finesses");
    }
    if (response.statusCode == 201) {
      // TODO
    }
  }

  static Future<dynamic> loginUser(User currUser) async {
    Map bodyMap = currUser.toMap();
    final http.Response response = await http.post(LOGIN_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(bodyMap));
    return [response.statusCode, response.body];
  }

  static Future<dynamic> signupUser(User currUser) async {
    var atSplit = currUser.username.split('@');
    var username = atSplit[0];
    var dotSplit = atSplit[1].split('.');
    var school = dotSplit[0];
    var payload = {
      "userName": username,
      "emailId": currUser.username,
      "password": currUser.password,
      "school": school,
      "points": 0
    };

    final http.Response response = await http.post(SIGNUP_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(payload));

    return [response.statusCode, response.body];
  }

  // Sign in callback
  static Future<String> authUser(LoginData data) async {
    User currUser = User.userAdd(data.name, data.password);
    var resp = await Network.loginUser(currUser);
    var status = resp[0];
    if (status == 400) {
      return 'Username or password is incorrect.';
    }
    return null;
  }

  // Forgot Password callback
  static Future<String> recoverPassword(String email) async {
    var emailCheck = validateEmail(email);
    const VALID_STATUS = null;
    if (emailCheck == VALID_STATUS) {
      var payload = {
        "emailId": email
      };
      final http.Response response = await http.post(PASSWORD_RESET_URL,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'api_token': token
          },
          body: json.encode(payload));
      if (response.statusCode == 200) {
        return "Password Reset Link sent to email";
      } else {
        return "Password Reset request failed";
      }
    } else {
      return emailCheck;
    }
  }

  // Sign up callback
  static Future<String> createUser(LoginData data) async {
    User newUser = User.userAdd(data.name, data.password);
    var resp = await Network.signupUser(newUser);
    var status = resp[0], respBody = json.decode(resp[1]);
    if (status == 400) {
      return respBody['msg'];
    }
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
}
