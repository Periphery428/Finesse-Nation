import 'dart:typed_data';
import 'dart:convert';

class Finesse {
  String eventId;
  String title;
  String description;
  String image;
  String location;
  String duration;
  String type;
  DateTime timePosted;
  bool active;

  static finesseAdd(
      title, description, image, location, duration, type, timePosted,
      {bool active = true}) {
    return Finesse(null, title, description, image, location, duration, type,
        timePosted, active);
  }

  Finesse(this.eventId, this.title, this.description, this.image, this.location,
      this.duration, this.type, this.timePosted, this.active);

  factory Finesse.fromJson(Map<String, dynamic> json) {
    //Filter the results based on applied filters.

    return Finesse(
      json['_id'],
      json['name'] != null ? json['name'] : "",
      json['description'] != null ? json['description'] : "",
      json['image'] != null ? json['image'] : "",
      json['location'] != null ? json['location'] : "",
      json['duration'] != null ? json['duration'] : "",
      json['type'] != null ? json['type'] : "",
      json['timePosted'] != null ? DateTime.parse(json['timePosted']) : null,
      json['active'] != null ? json['active'] : true,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = title;
    map["description"] = description;
    map["image"] = image;
    map["location"] = location;
    map["duration"] = duration;
    map["type"] = type;
    map['timePosted'] = timePosted.toString();
    map['active'] = true;
    return map;
  }

  void setId(id) {
    this.eventId = id;
  }

  void setDescription(desc) {
    this.description = desc;
  }

  String getImage() {
    return image;
  }

  Uint8List getConvertedImage() {
    return base64.decode(image);
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

  String getId() {
    return eventId;
  }

  DateTime getTimePosted() {
    return timePosted;
  }

  bool getActive() {
    return this.active;
  }
}
