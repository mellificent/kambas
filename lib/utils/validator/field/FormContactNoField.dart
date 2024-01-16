

import '../../../constants/app_strings.dart';
import '../BaseInput.dart';

enum FormContactNoValidationError { empty, minimum, invalid }

class FormContactNoField
    extends BaseInput<String, FormContactNoValidationError> {
  final String regex;
  final int minimum;
  const FormContactNoField.init({this.minimum = 11, this.regex = ''})
      : super(0, '');
  const FormContactNoField.value(String value,
      {this.minimum = 11, this.regex = ''})
      : super(0, value);
  const FormContactNoField.valueWithId(int id, String value,
      {this.minimum = 11, this.regex = ''})
      : super(id, value);

  @override
  FormContactNoValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return FormContactNoValidationError.empty;
    }
    if (value.length < minimum) return FormContactNoValidationError.minimum;
    if (regex != '') {
      return !RegExp(regex).hasMatch(value)
          ? FormContactNoValidationError.invalid
          : null;
    }
    return null;
  }

  @override
  String? getErrorMessage(FormContactNoValidationError? e) {
    switch (e) {
      case FormContactNoValidationError.minimum:
      case FormContactNoValidationError.invalid:
        return AppStrings.validator_invalid_contact_number;
      case FormContactNoValidationError.empty:
        return null;
      default:
        return null;
    }
  }
}
