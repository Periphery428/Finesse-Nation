import 'dart:math';

class Finesse {
  String _id;
  final String title;
  final String description;
  final String image;
  final String location;
  final String duration;
  final String type;
  final DateTime timePosted;


  static finesseAdd( title, description, image, location,
    duration, type, timePosted){
    return Finesse(null, title, description, image, location,
    duration, type, timePosted);
  }

  Finesse(this._id, this.title, this.description, this.image, this.location,
      this.duration, this.type, this.timePosted);

  factory Finesse.fromJson(Map<String, dynamic> json) {
    var rng = Random();
    var imgInt = rng.nextInt(2048);
    var imgStr = (imgInt < 100)
        ? 'https://wallup.net/wp-content/uploads/2017/10/25/484538-blue_hair-Rem-Re_Zero_Kara_Hajimeru_Isekai_Seikatsu-anime_girls-anime-748x421.jpg?id=${rng.nextInt(2048)}'
        : 'https://picsum.photos/500?id=$imgInt';
    return Finesse(
      json['_id'],
      json['name'] != null ? json['name'] : "",
      json['description'] != null ? json['description'] : "",
      imgStr,
      json['location'] != null ? json['location'] : "",
      json['duration'] != null ? json['duration'] : "",
      json['type'] != null ? json['type'] : "",
      json['timePosted'] != null ? DateTime.parse(json['timePosted']) : null,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = title;
    map["description"] = description;
    map["image"] = null;
    map["location"] = location;
    map["duration"] = duration;
    map["type"] = type;
    map['timePosted'] = timePosted.toString();
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

  String getId(){
    return _id;
  }

  DateTime getTimePosted(){
    return timePosted;
  }
}
