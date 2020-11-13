class Freight {
  int id;
  String name;
  double value;

 int get getId => id;

 set setId(int id) => this.id = id;

 String get getName => name;

 set setName(String name) => this.name = name;

 double get getValue => value;

 set setValue(double value) => this.value = value;

 Freight(this.id, this.name, this.value);

 Freight.fromJson(Map<String,dynamic> json) {
   id = json ["id"];
   name = json["name"];
  if (json['value'] is double ) {
     value = json['value'];
  }
  else if  (json['value'] is int )  {
    value = json['value'] + .0;
  } 
 }
}