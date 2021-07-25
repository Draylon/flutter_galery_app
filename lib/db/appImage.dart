class AppImage {
  //(titulo, coment ́ario, data atual, latitude, longitude e foto)
  int? id;
  String? titulo;
  String? comment;
  String? data;
  double? lat;
  double? long;
  String? img;

  AppImage(this.titulo,this.comment,this.data,this.lat,this.long,this.img);

  AppImage.fromMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.titulo = json['title'];
    this.comment = json['comment'];
    this.data = json['data'];
    this.lat = json['lat'];
    this.long = json['long'];
    this.img = json['img'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.titulo,
      'comment': this.comment,
      'data': this.data,
      'lat': this.lat,
      'long': this.long,
      'img': this.img,
    };
  }

  @override
  String toString() {
    return '$id - $titulo';
  }
}
