class EmailValidationApi {
  EmailValidationApi({
    required this.status,
    required this.errorCode,
     this.error,
    required this.validate,
  });
  late final String status;
  late final String errorCode;
  late final Null error;
  late final String validate;
  
  EmailValidationApi.fromJson(Map<String, dynamic> json){
    status = json['status'];
    errorCode = json['errorCode'];
    error = null;
    validate = json['validate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['errorCode'] = errorCode;
    _data['error'] = error;
    _data['validate'] = validate;
    return _data;
  }
}