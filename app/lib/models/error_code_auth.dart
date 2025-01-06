class ErrorCode{

  ErrorCode({
    required this.code,
    required this.message,
    // required this.httpStatus
  });

  final int code;
  final String message;
  // final String httpStatus;

  factory ErrorCode.fromJson(Map<String, dynamic> json) {
    if(json is String){
      return ErrorCode(code: 200, message: "Success");
    }
    return ErrorCode(
      code: json['code'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      // httpStatus: json['http_status'] ?? 'No status'
    );
  }
}