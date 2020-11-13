class ResetToken {
  int id;
  String token;

  ResetToken(this.id, this.token);

  ResetToken.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    token = json["token"];
  }
}
