class ResponseErrorMessage {
  String errorMsg;
  bool? relogin;

  ResponseErrorMessage({
    required this.errorMsg,
    this.relogin = false,
  });
}
