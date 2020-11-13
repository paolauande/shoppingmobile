import 'package:scoped_model/scoped_model.dart';

class Address extends Model {
  int id;
  String street;
  String complement;
  String number;
  String neighborhood;
  String city;
  String state;
  String cep;
  int userId;

  Address();

  Address.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    street = json['street'];
    complement = json['complement'];
    number = json['number'];
    neighborhood = json['neighborhood'];
    city = json['city'];
    state = json['state'];
    cep = json['cep'];
    userId = json['user_id'];
  }

  Address.fromCEPJson(Map<String, dynamic> parsedJson) {
    cep = parsedJson['cep'];
    street = parsedJson['logradouro'];
    neighborhood = parsedJson['bairro'];
    city = parsedJson['localidade'];
    state = parsedJson['uf'];
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'complement': complement,
        'number': number,
        'neighborhood': neighborhood,
        'city': city,
        'state': state,
        'cep': cep
      };

  @override
  String toString() {
    return " Address: [ id :" +
        (id == null ? "null" : id.toString()) +
        "], [street: " +
        (street == null ? "null" : street) +
        "], " +
        "  [complement: " +
        (complement == null ? "null" : complement) +
        "] " +
        "  [neighborhood: " +
        (neighborhood == null ? "null" : neighborhood) +
        "] " +
        "  [city: " +
        (city == null ? "null" : city) +
        "] " +
        "  [state: " +
        (state == null ? "null" : state) +
        "] " +
        "  [number: " +
        (number == null ? "null" : number) +
        "] " +
        "  [cep: " +
        (cep == null ? "null" : cep) +
        "] ";
  }

  onChanged() {
    notifyListeners();
  }
}
