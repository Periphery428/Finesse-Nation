import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finesse_nation/main.dart';

class Finesse {
  final String title;
  final String description;
  final String image;
  final String location;
  final String duration;
  final String type;

  Finesse(this.title, this.description, this.image, this.location,
      this.duration, this.type);

  factory Finesse.fromJson(Map<String, dynamic> json) {
    return Finesse(
      json['name'] != null ? json['name'] : "",
      json['description'] != null ? json['description'] : "",
      "image",
      "22",
      "23",
      json['duration'] != null ? json['duration'] : "",
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = title;
    map["location"] = location;
    map["description"] = description;
    map["duration"] = duration;

    return map;
  }

  String getImage() {
    return image;
  }

  String getTitle() {
    return title;
  }

  String getLocation() {
    return location;
  }

  String getDescription() {
    return description;
  }

  String getDuration() {
    return duration;
  }

  String getType() {
    return type;
  }

  Future<Finesse> addFinesse() async {
    Map bodyMap = this.toMap();
    final http.Response response = await http.post(POST_URL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(bodyMap));

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data");
    }
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response, then parse the JSON.
      return Finesse.fromJson(json.decode(response.body));
    }
  }

  void removeFinesse() {
    //TODO: Remove the most recent finesse
  }
}
