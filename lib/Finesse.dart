import 'dart:math';

class Finesse {
  final String title;
  final String description;
  final String image;
  final String location;
  final String duration;
  final String type;
  String _id;


  static finesseAdd( title, description, image, location,
    duration, type){
    return Finesse(null, title, description, image, location,
    duration, type);

  }

  Finesse(this._id, this.title, this.description, this.image, this.location,
      this.duration, this.type);

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
      json['type'] != null ? json['type'] : "",
      json['duration'] != null ? json['duration'] : "",
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = title;
    map["description"] = description;
    //Image
    map["location"] = location;
    map["duration"] = duration;
    map["type"] = type;

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

  String get_Id(){
    return _id;
  }
}
