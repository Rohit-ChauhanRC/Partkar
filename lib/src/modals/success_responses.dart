class SuccessResponseModel {
  final bool status;
  final int code;
  final String message;

  SuccessResponseModel.fromJSON(Map<String, dynamic> parsedJSON)
      : status = parsedJSON['status'],
        code = parsedJSON['code'],
        message = parsedJSON['message'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'code': code,
      'message': message,
    };
  }
}
