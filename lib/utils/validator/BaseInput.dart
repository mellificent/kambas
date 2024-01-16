enum InputStatus {
  empty,
  valid,
  invalid,
}

abstract class BaseInput<T, E> {
  const BaseInput(this.id, this.value);

  final int id;
  final T? value;

  E? validator(T? value);

  String? getErrorMessage(E? e);

  bool get valid => value != null ? validator(value!) == null : false;
  bool get invalid => value != null ? validator(value!) != null : true;

  E? get error => validator(value);

  String? get errorMessage => getErrorMessage(error);
}
