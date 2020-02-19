class Finesse {
  String title;
  String description;
  String location;
  String type;
  String duration;

  //String image; //TODO:

  Finesse(
      this.title, this.description, this.location, this.type, this.duration);

  getTitle() {
    return this.title;
  }

  getBody() {
    return this.description;
  }

  getDuration() {
    return this.duration;
  }
}
