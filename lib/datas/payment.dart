class Payment {
  int id;
  String name;

  int get getId => id;

  set setId(int id) => this.id = id;

  String get getName => name;

  set setName(String name) => this.name = name;

  Payment(this.id, this.name);

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
