import 'package:email_validator/email_validator.dart';

import '../../../constants/app_strings.dart';
import '../BaseInput.dart';

enum EmailValidationError { empty, invalidEmail }

class FormEmail extends BaseInput<String, EmailValidationError> {
  const FormEmail.init() : super(0, '');
  const FormEmail.value(String value) : super(0, value);
  const FormEmail.valueWithId(int id, String value) : super(id, value);

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!EmailValidator.validate(value)) {
      return EmailValidationError.invalidEmail;
    } else {
      return null;
    }
  }

  @override
  String? getErrorMessage(EmailValidationError? e) {
    switch (e) {
      case EmailValidationError.empty:
        return null;
      case EmailValidationError.invalidEmail:
        return AppStrings.validator_email_format;
      default:
        return null;
    }
  }
}
