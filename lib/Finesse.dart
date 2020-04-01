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
  bool isActive;
  Uint8List convertedImage;

  static finesseAdd(
      title, description, image, location, duration, type, timePosted) {
    return Finesse(
        null, title, description, image, location, duration, type, timePosted);
  }

  Finesse(var eventId, var title, var description, var image, var location,
      var duration, var type, var timePosted) {
    this.eventId = eventId;
    this.title = title;
    this.description = description;
    this.image = image;
    this.location = location;
    this.duration = duration;
    this.type = type;
    this.timePosted = timePosted;
    this.convertedImage = base64.decode(image);
  }

  static dynamic parse(var time) {
    if (time != null) {
      try {
        String timeStr = time.toString();
        DateTime res = DateTime.parse(timeStr);
        return res;
      } catch (Exception) {
        print('invalid datetime format');
        print(time);
      }
    }
    return null;
  }

  factory Finesse.fromJson(Map<String, dynamic> json) {
//    print('creating finesse');
    Finesse fin = Finesse(
      json['_id'],
      json['name'],
      json['description'] ?? "",
      json['image'] ?? "",
      json['location'],
      json['duration']?.toString() ?? "",
      json['type'],
      parse(json['timePosted']),
    );
//    print('created finesse = ${fin.getTitle()}');
    return fin;
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
    return convertedImage;
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
}
