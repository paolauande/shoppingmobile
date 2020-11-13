class Category {
  String name;
  String image;
  int id;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getImage => image;

  set setImage(String image) => this.image = image;

  int get getId => id;

  set setId(int id) => this.id = id;

  Category(
    this.name,
    this.image,
    this.id,
  );

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
