import 'dart:convert';

import '../models/object/LocationItem.dart';
import '../repository/HardCodeRepository.dart';

class ProviderSelections {
  final HardCodeRepository hardCodeRepository;

  const ProviderSelections({
    required this.hardCodeRepository,
  });

  Future<List<LocationItem>> getProvinces() async {
    String province = await hardCodeRepository.getProvinces();
    var map = json.decode(province);
    var records = map['RECORDS'];

    List<LocationItem> finalList = [];
    records.forEach((value) {
      finalList.add(LocationItem(
          id: value['id'], code: value['provCode'], desc: value['provDesc']));
    });
    finalList.sort((a, b) {
      return (a.desc.toString().toLowerCase())
          .compareTo(b.desc.toString().toLowerCase());
    });
    return finalList;
  }

  Future<List<LocationItem>> getCity(String id) async {
    String cities = await hardCodeRepository.getCities();
    var map = json.decode(cities);
    var records = map['RECORDS'];

    List<LocationItem> finalList = [];
    records.forEach((value) {
      if (value['provCode'] == id) {
        finalList.add(LocationItem(
            id: value['id'],
            code: value['citymunCode'],
            desc: value['citymunDesc']));
      }
    });
    finalList.sort((a, b) {
      return (a.desc.toString().toLowerCase())
          .compareTo(b.desc.toString().toLowerCase());
    });
    return finalList;
  }

  Future<List<LocationItem>> getBarangay(String cityCode) async {
    String cities = await hardCodeRepository.getBarangays();
    var map = json.decode(cities);
    var records = map['RECORDS'];

    List<LocationItem> finalList = [];
    records.forEach((value) {
      if (value['citymunCode'] == cityCode) {
        finalList.add(LocationItem(
            id: value['id'],
            code: value['brgyCode'],
            desc: value['brgyDesc']));
      }
    });
    finalList.sort((a, b) {
      return (a.desc.toString().toLowerCase())
          .compareTo(b.desc.toString().toLowerCase());
    });
    return finalList;
  }

  Future<List<LocationItem>> searchList(
      String query, List<LocationItem> list) async {
    List<LocationItem> finalList = [];
    for (var element in list) {
      if (element.desc.toLowerCase().contains(query.toLowerCase())) {
        finalList.add(element);
      }
    }

    return finalList;
  }

}
