class FreightRequest {
  int id;
  int userId;
  String state;
  String city;
  String neighborhood;

  FreightRequest(this.state, this.city, this.neighborhood);

  Map<String, dynamic> toJson() => {
        'estado': state,
        'cidade': city,
        'bairro': neighborhood,
      };

  FreightRequest.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    state = json["estado"];
    city = json["cidade"];
    neighborhood = json["bairro"];
  }
}
