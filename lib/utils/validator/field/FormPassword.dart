
import 'package:easy_localization/easy_localization.dart';
import 'package:kambas/constants/app_strings.dart';

import '../BaseInput.dart';

enum PasswordValidationError { empty, underMinimum }

class FormPassword extends BaseInput<String, PasswordValidationError> {
  final int minPassword;
  final bool obscure;
  const FormPassword.init({this.minPassword = 8, this.obscure = true})
      : super(0, '');
  const FormPassword.value(String? value,
      {this.minPassword = 8, this.obscure = true})
      : super(0, value);
  const FormPassword.valueWithId(int id, String value,
      {this.minPassword = 8, this.obscure = true})
      : super(id, value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < minPassword) {
      return PasswordValidationError.underMinimum;
    } else {
      return null;
    }
  }

  @override
  String? getErrorMessage(PasswordValidationError? e) {
    switch (e) {
      case PasswordValidationError.empty:
        return null;
      case PasswordValidationError.underMinimum:
        return tr(AppStrings.validator_password_min_char,
            args: [minPassword.toString()]);
      default:
        return null;
    }
  }
}
