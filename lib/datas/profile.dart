class DefineProfile {
  int id;

  DefineProfile.fromJson(Map<String,dynamic> json) {
    id = json['id'];
  }
}