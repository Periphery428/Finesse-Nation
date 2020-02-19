class Finesse{
  final String title;
  final String body;
  final String image;

  Finesse(this.title, this.body, this.image);

  factory Finesse.fromJson(Map<String, dynamic> json){
      return Finesse(
        json['name'] != null ? json['name'] : "",
        json['description'],
        json['duration'],
    );
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