import 'dart:convert';

import 'package:shoppingmobile/datas/user.dart';
import 'package:shoppingmobile/services/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  Login();

  static fromJson(Map<String, dynamic> json) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expires_at', json['token']['expires_at']);
    prefs.setString('token', json['token']['token']);
    if (json['profiles'].length > 0)
      prefs.setString('profileId', json['profiles'][0]['id'].toString());
    prefs.setString('user', jsonEncode(json['user']));
  }

  static Future<String> getProfileId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("profileId");
  }

  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String> getExpiresAt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("expires_at");
  }

  static Future<bool> isTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) {
      return true;
    }
    String expiresAt = prefs.getString("expires_at");
    DateTime expireDate = DateTime.parse(expiresAt);
    if (DateTime.now().isAfter(expireDate)) {
      return true;
    }
    return false;
  }

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromJson(jsonDecode(prefs.getString("user")));
  }

  static Future<void> remove() async {
    UserApi.logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("profileId");
    prefs.remove("token");
    prefs.remove("expires_at");
    prefs.remove("user");
  }

  /*  @override
  String toString() {
    return " [ token :" +
        (getToken() == null ? "null" : getToken()) +
        "], [profileId: " +
        (getProfileId() == null ? "null" : getProfileId()) +
        "], [expire: " +
        (getExpiresAt() == null ? "null" : getExpiresAt()) +
        "], [user: " +
        (getUser() == null ? "null" : getUser()) +
        "]";
  } */
}
