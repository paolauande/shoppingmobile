class Product {
  int id;
  String name;
  String image;
  String description;
  double price;
  String preparation;
  int categoryId;

  int get getId => id;

  set setId(int id) => this.id = id;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getImage => image;

  set setImage(String image) => this.image = image;

  String get getDescription => description;

  set setDescription(String description) => this.description = description;

  double get getPrice => price;

  set setPrice(double price) => this.price = price;

  String get getPrepatation => preparation;

  set setPreparation(String preparation) => this.preparation = preparation;

  int get getCategoryId => categoryId;

  set setCategoryId(int categoryId) => this.categoryId = categoryId;

  Product(this.id, this.name, this.description, this.price, this.image,
      this.preparation, this.categoryId);

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = double.parse(json['price']);
    image = json['image'];
    preparation = json['preparation'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "preparation": preparation,
      "image": image
    };
  }
}
