import 'package:scoped_model/scoped_model.dart';

class User extends Model {
  int id;
  String username;
  String name;
  String email;
  String cpf;
  String cellphone;

  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json["login"];
    name = json["name"];
    email = json["email"];
    cpf = json ['cpf'];
    cellphone = json["cellphone"];
  }
 
  Map<String, dynamic> toJson() => {
    'name': name,
    'login': username,
  };


  @override
  String toString() {
    
    return " [ id :" + (id == null ? "null" : id.toString()) + "], [email: " + (email == null ? "null" : email) + "], " +
    "  [username: " + (username == null ? "null" : username) + "] ";
  }

    onChanged () {
    notifyListeners();
  }
}
