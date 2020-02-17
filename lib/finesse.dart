class Finesse {
  String title;
  String description;
  String location;
  String type;
  int duration;

  //String image; //TODO:

  Finesse(
      this.title, this.description, this.location, this.type, this.duration);

  getTitle() {
    return this.title;
  }
}
