import '../BaseInput.dart';

enum RequiredFieldValidationError { empty }

class FormNonRequiredField
    extends BaseInput<String, RequiredFieldValidationError> {
  const FormNonRequiredField.init() : super(0, '');
  const FormNonRequiredField.value(String value) : super(0, value);
  const FormNonRequiredField.valueWithId(int id, String value)
      : super(id, value);

  @override
  RequiredFieldValidationError? validator(String? value) {
    return null;
  }

  @override
  String? getErrorMessage(RequiredFieldValidationError? e) {
    return null;
  }
}
