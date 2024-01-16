import 'BaseInput.dart';

class Validator {
  static ValidationStatus validate(List<BaseInput> list) {
    return list.any((input) => input.valid == false)
        ? ValidationStatus.invalid
        : ValidationStatus.valid;
  }
}

enum ValidationStatus {
  notvalidated,
  valid,
  invalid,
}

mixin ValidatorMixins {
  ValidationStatus get status => Validator.validate(inputs);

  List<BaseInput> get inputs;
}
