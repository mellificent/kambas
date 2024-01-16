class LocationItem {
  late int _id;
  late String _code;
  late String _desc;

  LocationItem({required int id, required String code, required String desc}) {
    _id = id;
    _code = code;
    _desc = desc;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get code => _code;
  set code(String code) => _code = code;
  String get desc => _desc;
  set desc(String desc) => _desc = desc;

  LocationItem.fromJson(Map<String, dynamic> json, String code, String desc) {
    _id = json['id'];
    _code = json[code];
    _desc = json[desc];
  }

  Map<String, dynamic> toJson(String code, String desc) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data[code] = _code;
    data[desc] = _desc;
    return data;
  }

  bool isMatched(String query) {
    var lowercaseQuery = query.toLowerCase();
    return _desc.toLowerCase().contains(lowercaseQuery);
  }
}
