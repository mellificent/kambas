import '../../../constants/app_strings.dart';
import '../BaseInput.dart';

enum ConfirmPasswordValidationError {
  bothEmpty,
  emptyConfirmPassword,
  notMatched
}

class FormConfirmPassword
    extends BaseInput<ConfirmPassword, ConfirmPasswordValidationError> {
  final int minPassword;
  final bool obscure;
  const FormConfirmPassword.init({this.minPassword = 8, this.obscure = true})
      : super(0, const ConfirmPassword(null, null));
  const FormConfirmPassword.value(ConfirmPassword value,
      {this.minPassword = 8, this.obscure = true})
      : super(0, value);
  const FormConfirmPassword.valueWithId(int id, ConfirmPassword value,
      {this.minPassword = 8, this.obscure = true})
      : super(id, value);

  @override
  ConfirmPasswordValidationError? validator(ConfirmPassword? value) {
    if (value == null ||
        (value.password == null && value.confirmPassword == null))
      return ConfirmPasswordValidationError.bothEmpty;
    else if ((value.password != null && value.password!.isNotEmpty) &&
        (value.confirmPassword == null || value.confirmPassword!.isEmpty))
      return ConfirmPasswordValidationError.emptyConfirmPassword;
    else if (value.password != value.confirmPassword)
      return ConfirmPasswordValidationError.notMatched;
    else
      return null;
  }

  @override
  String? getErrorMessage(ConfirmPasswordValidationError? e) {
    switch (e) {
      case ConfirmPasswordValidationError.bothEmpty:
        return null;
      case ConfirmPasswordValidationError.notMatched:
        return AppStrings.validator_password_not_match;
      case ConfirmPasswordValidationError.emptyConfirmPassword:
        return null;
      default:
        return null;
    }
  }
}

class ConfirmPassword {
  final String? password;
  final String? confirmPassword;

  const ConfirmPassword(this.password, this.confirmPassword);
}
