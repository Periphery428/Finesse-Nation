import 'dart:typed_data';
import 'dart:convert';
import 'User.dart';

class Finesse {
  String eventId;
  String eventTitle;
  String description;
  String image;
  String location;
  String duration;
  String category;
  DateTime postedTime;
  List isActive;
  Uint8List convertedImage;
  String emailId;
  String school;

  static finesseAdd(
      title, description, image, location, duration, category, timePosted,
      {List isActive, String school, String email}) {
    return Finesse(
        null,
        title,
        description,
        image,
        location,
        duration,
        category,
        timePosted,
        isActive,
        User.currentUser?.school ?? 'test',
        User.currentUser?.email ?? 'test');
  }

  Finesse(
      var eventId,
      var title,
      var description,
      var image,
      var location,
      var duration,
      var category,
      var postedTime,
      var isActive,
      var school,
      var emailId) {
    this.eventId = eventId;
    this.eventTitle = title;
    this.description = description;
    this.image = image;
    this.location = location;
    this.duration = duration;
    this.category = category;
    this.postedTime = postedTime;
    this.convertedImage = image == null ? null : base64.decode(image);
    this.isActive = isActive;
    this.school = school;
    this.emailId = emailId;
  }

  static dynamic parse(var time) {
    if (time != null) {
      try {
        String timeStr = time.toString();
        DateTime res = DateTime.parse(timeStr);
        return res;
      } catch (Exception) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  factory Finesse.fromJson(Map<String, dynamic> json) {
//    print('creating finesse');
    Finesse fin = Finesse(
      json['_id'],
      json['eventTitle'] ?? "",
      json['description'] ?? "",
      json['image'] ?? "",
      json['location'] ?? "",
      json['duration'] ?? "",
      json['category'] ?? "",
      parse(json['postedTime']) ?? DateTime.now(),
      json['isActive'] ?? [],
      json['school'] ?? "",
      json['emailId'] ?? "",
    );
//    print('created finesse = ${fin.getTitle()}');
    return fin;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["eventTitle"] = eventTitle;
    map["description"] = description;
    map["image"] = image;
    map["location"] = location;
    map["duration"] = duration;
    map["category"] = category;
    map['postedTime'] = postedTime.toString();
    map['isActive'] = isActive;

    map['school'] = school;
    map['emailId'] = emailId;
    return map;
  }

  void setId(id) {
    this.eventId = id;
  }

  void setDescription(desc) {
    this.description = desc;
  }

  void setActive(activeList) {
    this.isActive = activeList;
  }

  String getImage() {
    return image;
  }

  Uint8List getConvertedImage() {
    return convertedImage;
  }

  String getTitle() {
    return eventTitle;
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

  String getCategory() {
    return category;
  }

  String getId() {
    return eventId;
  }

  DateTime getPostedTime() {
    return postedTime;
  }

  List getActive() {
    return this.isActive;
  }

  String getEmailId() {
    return this.emailId;
  }
}
