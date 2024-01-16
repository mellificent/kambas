import 'package:flutter/services.dart';

import '../constants/AppSelections.dart';

class HardCodeRepository {
  List<String> getGenderList() => AppSelections.genderList;
  Future<String> getProvinces() => rootBundle.loadString('assets/data/provinces.json');
  Future<String> getCities() => rootBundle.loadString('assets/data/city.json');
  Future<String> getBarangays() => rootBundle.loadString('assets/data/barangay.json');

  Future<String> getEULA() => rootBundle.loadString('assets/html/agreement/index.html');
  Future<String> getUserAgreement() => rootBundle.loadString('assets/html/agreement/payo_agreement.html');
}
