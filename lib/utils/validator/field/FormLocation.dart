import '../../../models/object/LocationBundle.dart';
import '../BaseInput.dart';

enum RequiredFieldValidationError { empty }

class FormLocation
    extends BaseInput<LocationBundle, RequiredFieldValidationError> {
  final bool isAllLocationRequired;
  const FormLocation.init({this.isAllLocationRequired = false}) : super(0, null);
  const FormLocation.value(LocationBundle value, {this.isAllLocationRequired = false}) : super(0, value);
  const FormLocation.valueWithId(int id, LocationBundle value, {this.isAllLocationRequired = false})
      : super(id, value);

  @override
  RequiredFieldValidationError? validator(LocationBundle? value) {
    if (value == null) return RequiredFieldValidationError.empty;
    if (value.province == null) return RequiredFieldValidationError.empty;
    if (isAllLocationRequired) {
      if (value.city == null) return RequiredFieldValidationError.empty;
      if (value.barangay == null) return RequiredFieldValidationError.empty;
    }

    return null;
  }

  @override
  String? getErrorMessage(RequiredFieldValidationError? e) {
    switch (e) {
      case RequiredFieldValidationError.empty:
        return null;
      default:
        return null;
    }
  }
}
