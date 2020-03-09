import 'dart:convert';

import 'package:finesse_nation/Finesse.dart';
import 'package:http/http.dart' as http;
import '.env.dart';

class Network {
  static const DELETE_URL =
      'https://finesse-nation.herokuapp.com/api/food/deleteEvent';
  static const ADD_URL =
      'https://finesse-nation.herokuapp.com/api/food/addEvent';
  static const GET_URL =
      'https://finesse-nation.herokuapp.com/api/food/getEvents';
  static const UPDATE_URL =
      'https://finesse-nation.herokuapp.com/api/food/updateEvent';

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
      print(response.toString());
      throw Exception('Failed to load finesses');
    }
  }

  static void removeFinesse(Finesse newFinesse) async {
    var jsonObject = {"eventId": newFinesse.getId()};
    final http.Response response = await http.post(DELETE_URL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'api_token': token
        },
        body: json.encode(jsonObject));

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data");
    }
    if (response.statusCode == 201) {
      // TODO
    }
  }
}

void main() {
  print(Network.token);
}
