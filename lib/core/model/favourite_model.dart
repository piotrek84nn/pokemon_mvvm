class Favourite{
  int id;
  int position;
  final String imgUrl;
  final String name;

  Favourite({required this.id, required this.position, required this.imgUrl, required this.name});

  Favourite.fromMap(Map<String, dynamic> item):
        id = item["id"],
        position = item["position"],
        imgUrl = item["imgUrl"],
        name = item["name"];

  Map<String, Object> toMap(){
    return {'id': id, 'position': position, 'imgUrl': imgUrl, 'name': name};
  }
}