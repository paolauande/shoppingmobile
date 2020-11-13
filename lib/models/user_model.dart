class Login {
  //bool authenticated;
  String expiration;
  String token;
  String message;

  Login({this.expiration, this.token, this.message});

  Login.fromJson(Map<String, dynamic> json) {
    //authenticated = json['authenticated'];
    expiration = json['expires_at'];
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['authenticated'] = this.authenticated;
    data['expires_at'] = this.expiration;
    data['token'] = this.token;
    data['message'] = this.message;
    return data;
  }
}

/* class UserModel extends Model {

  bool isLoading = false;

  void logIn() async {
    isLoading = true;
    notifyListeners();
  }
}
 */
