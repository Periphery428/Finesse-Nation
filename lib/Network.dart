import 'dart:convert';

import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '.env.dart';
import 'package:flutter_login/flutter_login.dart';

class Network {
  static const DOMAIN = 'https://finesse-nation.herokuapp.com/api/';
  static const DELETE_URL = DOMAIN + 'food/deleteEvent';
  static const ADD_URL = DOMAIN + 'food/addEvent';
  static const GET_URL = DOMAIN + 'food/getEvents';
  static const UPDATE_URL = DOMAIN + 'food/updateEvent';
  static const LOGIN_URL = DOMAIN + 'user/login';
  static const SIGNUP_URL = DOMAIN + 'user/signup';

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
      responseJson = await applyFilters(responseJson);
      return responseJson;
    } else {
      print('nope');
      print(token);
      print(response.statusCode);
      print(response.toString());
      throw Exception('Failed to load finesses');
    }
  }

  static Future<List<Finesse>> applyFilters(responseJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool activeFilter = prefs.getBool('activeFilter') ?? true;
    final bool typeFilter = prefs.getBool('typeFilter') ?? true;
    List<Finesse> filteredFinesses = new List<Finesse>.from(responseJson);

    print(activeFilter);
    print(typeFilter);
    if (activeFilter == false) {
      filteredFinesses.removeWhere((value) => value.getActive() == false);
    }
    if (typeFilter == false) {
      filteredFinesses.removeWhere((value) => value.getType() == "OTHER");
    }
    return filteredFinesses;
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
    var username = currUser.username.split('@')[0];
    var payload = {
      "userName": username,
      "emailId": currUser.username,
      "password": currUser.password
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
    var status = resp[0], respBody = resp[1];
    if (status == 400) {
      return 'Username or password is incorrect.';
    }
    return null;
  }

  // Forgot Password callback
  static Future<String> recoverPassword(String name) async {
    // TODO
    return 'Password recovery feature not yet built. Try again later.';
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
