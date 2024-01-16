

import '../../../constants/app_strings.dart';
import '../BaseInput.dart';
import 'package:intl/intl.dart';

enum FormBirthDateValidationError { empty, invalidDate }

class FormBirthDate extends BaseInput<String, FormBirthDateValidationError> {
  const FormBirthDate.init() : super(0, '');
  const FormBirthDate.value(String value) : super(0, value);
  const FormBirthDate.valueWithId(int id, String value) : super(id, value);

  @override
  FormBirthDateValidationError? validator(String? value) {
    if (value == null || value.isEmpty)
      return FormBirthDateValidationError.empty;
    if (value.length != 10)
      return FormBirthDateValidationError.invalidDate;
    else {
      try {
        var dateInput = formatDateInput();
        if (dateInput.isAfter(DateTime.now())) {
          return FormBirthDateValidationError.invalidDate;
        }

        return null;
      } catch (e) {
        return FormBirthDateValidationError.invalidDate;
      }
    }
  }

  DateTime formatDateInput() {
    var tempVal = value!.replaceAll('/', '-');
    return DateFormat('MM-dd-yyyy').parseStrict(tempVal);
  }

  String get valueFormatted => (value != null || value!.isNotEmpty)
      ? DateFormat('yyyy-MM-dd').format(
          DateFormat('MM-dd-yyyy').parseStrict(value!.replaceAll('/', '-')))
      : '';

  @override
  String? getErrorMessage(FormBirthDateValidationError? e) {
    switch (e) {
      case FormBirthDateValidationError.empty:
        return null;
      case FormBirthDateValidationError.invalidDate:
        return AppStrings.validator_invalid_date;
      default:
        return null;
    }
  }
}
