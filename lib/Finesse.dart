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
}
