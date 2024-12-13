class PetModel {
  int id;
  String name;
  String breed;
  double latitude;
  double longitude;

  PetModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.latitude,
    required this.longitude
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
        id: json['id'],
        name: json['name'],
        breed: json['breed'],
        latitude: json['latitude'],
        longitude: json['longitude']
    );
  }
}