import 'dart:convert';

import 'package:finesse_nation/Finesse.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
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
  static final serverKey = environment['FINESSE_SERVER_KEY'];

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

  static Future<void> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<void> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<void> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      http.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {
            'body': '$body',
            'title': '$title',
            'image':
                'https://vignette.wikia.nocookie.net/rezero/images/0/02/Rem_Anime.png',
          },
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}

void main() {
  print(Network.token);
}
