class ResponseBundle<T, E> {
  T? response;
  E? error;

  ResponseBundle.success({this.response});
  ResponseBundle.failed({this.error});

  bool get isSuccess => (error == null);
}
