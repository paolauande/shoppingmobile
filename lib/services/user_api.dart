import 'dart:convert';
import 'package:shoppingmobile/datas/profile.dart';
import 'package:shoppingmobile/datas/resetToken.dart';
import 'package:shoppingmobile/datas/user.dart';
import 'package:shoppingmobile/widgets/config.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingmobile/models/login.dart';

class UserApi {
  static Future<Login> signup(String name, username, email, password, cpf,
      cellphone, usertype, usersituation) async {
    var url = Environment.API_ENDPOINT + '/api/auth/signup';

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    Map params = {
      "login": username,
      "password": password,
      "name": name,
      "email": email,
      "cellphone": cellphone,
      "cpf": cpf,
      "user_type_id": usertype,
      "user_situation_id": usersituation
    };

    var login = new Login();

    var _body = json.encode(params);

    print("json enviado : $_body");

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      Login.fromJson(mapResponse['data']);
    } else {
      login = null;
    }
    if (login != null) print("SignUp: " + login.toString());
    return login;
  }

  static Future<User> login(String username, String password) async {
    var url = Environment.API_ENDPOINT + '/api/auth/login';

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    Map params;

    if (username.contains("@"))
      params = {"email": username, "password": password};
    else
      params = {"login": username, "password": password};

    var _body = json.encode(params);

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      Login.fromJson(mapResponse['data']);
      print("Logado com sucesso!");
      return Login.getUser();
    }
    return null;
  }

  static Future<String> logout() async {
    var url = Environment.API_ENDPOINT + '/api/auth/logout';
    String logoutRequest;
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      logoutRequest = mapResponse['message'];
      print(logoutRequest);
    }
    return logoutRequest;
  }

  static Future<User> getUserData() async {
    var user = await Login.getUser();

    User userdata;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT + '/api/users/' + user.id.toString();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      userdata = User.fromJson(mapResponse['data']);
    } else {
      userdata = null;
    }
    if (userdata != null) print("getUserData: " + userdata.toString());
    return userdata;
  }

  static Future<User> editUserData(User userData) async {
    var user = await Login.getUser();

    User edited;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    Map paramsAdress = {
      "name": userData.name,
      "login": userData.username,
      "email": userData.email,
    };

    var _body = json.encode(paramsAdress);

    var url = Environment.API_ENDPOINT + '/api/users/' + user.id.toString();

    var response = await http.put(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      edited = User.fromJson(mapResponse['data']);
    } else {
      edited = null;
    }
    if (edited != null) print("editedUserData: " + edited.toString());
    return edited;
  }

  static Future<DefineProfile> defineProfile() async {
    if (await Login.getProfileId() == null) {
      return null;
    }
    var defineProfile;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT +
        '/api/auth/define_profile/' +
        await Login.getProfileId();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      defineProfile = DefineProfile.fromJson(mapResponse);
    } else {
      defineProfile = null;
    }
    if (defineProfile != null)
      print("defineProfile: " + defineProfile.toString());
    return defineProfile;
  }

  static Future<bool> authToken() async {
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer " + await Login.getToken()
    };

    var url = Environment.API_ENDPOINT + '/api/auth/validate';

    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      String expiresAt = mapResponse['data']['token']['expires_at'];
      DateTime expireDate = DateTime.parse(expiresAt);
      if (DateTime.now().isAfter(expireDate)) {
        return true;
      }
    }
    return false;
  }

  static Future<ResetToken> validate(String cpf, String email) async {
    ResetToken resetToken;

    var url = Environment.API_ENDPOINT +
        '/api/valid/action/user/pass?cpf=' +
        cpf +
        '&email=' +
        email;

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      Map mapResponse = json.decode(response.body);
      resetToken = ResetToken.fromJson(mapResponse);
      print("Cpf e email validados!");
      return resetToken;
    }
    return null;
  }

  static void reset(ResetToken resetToken, String password) async {
    var url = Environment.API_ENDPOINT + '/api/reset/user/pass';

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    Map params = {
      "id": resetToken.id,
      "token": resetToken.token,
      "password": password,
    };

    var _body = json.encode(params);

    var response = await http.post(url, headers: header, body: _body);

    if (response.statusCode == 200) {
      print("Senha atualizada!");
      return;
    }
    throw Exception;
  }
}
