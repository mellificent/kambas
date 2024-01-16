

import 'package:easy_localization/easy_localization.dart';

import '../../../constants/app_strings.dart';
import '../BaseInput.dart';

enum RequiredFieldValidationError { empty, minimum, invalid }

class FormRequiredField
    extends BaseInput<String, RequiredFieldValidationError> {
  final String regex;
  final int minimum;
  const FormRequiredField.init({this.minimum = 2, this.regex = ''})
      : super(0, '');
  const FormRequiredField.value(String value,
      {this.minimum = 2, this.regex = ''})
      : super(0, value);
  const FormRequiredField.valueWithId(int id, String value,
      {this.minimum = 2, this.regex = ''})
      : super(id, value);

  @override
  RequiredFieldValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return RequiredFieldValidationError.empty;
    }
    if (value.length < minimum) return RequiredFieldValidationError.minimum;
    if (regex != '') {
      return RegExp(regex).hasMatch(value)
          ? RequiredFieldValidationError.invalid
          : null;
    }

    return null;
  }

  @override
  String? getErrorMessage(RequiredFieldValidationError? e) {
    switch (e) {
      case RequiredFieldValidationError.minimum:
        return tr(AppStrings.validator_min_length,
            args: [minimum.toString()]);
      case RequiredFieldValidationError.invalid:
        return AppStrings.validator_alphanumeric;
      case RequiredFieldValidationError.empty:
        return null;
      default:
        return null;
    }
  }
}
