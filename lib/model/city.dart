class City {
  String? cityId;
  String? type;
  String? cityName;

  City({this.cityId, this.type, this.cityName});

  City.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    type = json["type"];
    cityName = json["city_name"];
  }

  @override
  String toString() => cityName as String;

  static List<City> fromJsonList(List list) {
    if (list.isEmpty) return List<City>.empty();
    return list.map((item) => City.fromJson(item)).toList();
  }
}
