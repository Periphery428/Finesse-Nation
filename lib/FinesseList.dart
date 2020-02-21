import 'dart:convert';

import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/main.dart';
import 'package:http/http.dart' as http;

class FinesseList {
  static Future<List<Finesse>> fetchFinesses() async {
    final response = await http.get(GET_URL);
    var responseJson;
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var responseJson =
          data.map<Finesse>((json) => Finesse.fromJson(json)).toList();
      return responseJson;
    } else {
      throw Exception('Failed to load finesses');
    }
  }
}
