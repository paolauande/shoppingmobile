import 'dart:convert';

import 'package:shoppingmobile/datas/address.dart';
import 'package:shoppingmobile/models/login.dart';
import 'package:shoppingmobile/services/orders_api.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AddressApi {
  static Future<List<Address>> getUserAddresses() async {
    var user = await Login.getUser();

    List<Address> addresses;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT +
        '/api/addresses?search=user_id:' +
        user.id.toString();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);

      List listaResponse = mapResponse['data'];

      addresses = List<Address>();

      for (Map map in listaResponse) {
        Address a = Address.fromJson(map);
        addresses.add(a);
      }
    } else {
      addresses = null;
    }
    if (addresses != null) print("getUserAddress: " + addresses.toString());
    return addresses;
  }

  static Future<Address> saveAddress(bool isEdit, Address address) async {
    var user = await Login.getUser();

    Address saved;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    Map paramsAdress = {
      "street": address.street,
      "complement": address.complement,
      "number": address.number,
      "neighborhood": address.neighborhood,
      "city": address.city,
      "state": address.state,
      "cep": address.cep,
      "user_id": user.id
    };

    var _body = json.encode(paramsAdress);

    var urlPut =
        Environment.API_ENDPOINT + '/api/addresses/' + address.id.toString();

    var urlPost = Environment.API_ENDPOINT + '/api/addresses';

    var response;

    if (isEdit) {
      response = await http.put(urlPut, headers: header, body: _body);
    } else {
      response = await http.post(urlPost, headers: header, body: _body);
    }

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      saved = Address.fromJson(mapResponse['data']);
    } else {
      saved = null;
    }
    if (saved != null) print("SaveAddress: " + saved.toString());
    return saved;
  }

  static Future<bool> delete(int addressId) async {
    if (await OrdersApi.isAddressAvaliable(addressId) == true) {
      return false;
    }

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url =
        Environment.API_ENDPOINT + '/api/addresses/' + addressId.toString();

    var response = await http.delete(url, headers: header);

    return (response.statusCode == 200);
  }

  static Future<Address> getAddressById(int addressId) async {
    Address address;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url =
        Environment.API_ENDPOINT + '/api/addresses/' + addressId.toString();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      address = Address.fromJson(mapResponse['data']);
    } else {
      address = null;
    }
    if (address != null) print("getAddressById: " + address.toString());
    return address;
  }

  static Future<Address> getAddressByGeolocator() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    return geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position _currentPosition) =>
            AddressApi.getAddressFromLatLng(_currentPosition));
  }

  static Future<Address> getAddressFromLatLng(Position _currentPosition) {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    return geolocator
        .placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude)
        .then((List<Placemark> p) {
      Placemark place = p[0];
      String jsonAddress = '{"street":"' +
          place.thoroughfare +
          '","cep":"' +
          place.postalCode +
          '","city":"' +
          place.subAdministrativeArea +
          '","state":"' +
          place.administrativeArea +
          '", "neighborhood":"' +
          place.subLocality +
          '"}';
      Address address = Address.fromJson(jsonDecode(jsonAddress));
      print(address.toString());
      return address;
    }).catchError((error) {
      print(error);
      return null;
    });
  }

  static Future<Address> fetchCep({String cep}) async {
    final response = await http.get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      Map<String, dynamic> resp = json.decode(response.body);
      if (resp['erro'] == true) {
        throw Exception('Requisição inválida!');
      }
      return Address.fromCEPJson(json.decode(response.body));
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
