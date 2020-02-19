class Finesse{
  String title;
  String body;
  String duration;
  String image;

  Finesse(String title, String body, String img){
    this.title = title;
    this.body = body;
    this.image = img;
  }

  String getImage(){
    return image;
  }

  String getBody(){
    return body;
  }

  String getTitle(){
    return title;
  }
}