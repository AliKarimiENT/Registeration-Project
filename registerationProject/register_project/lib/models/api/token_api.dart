class TokenApi {
  TokenApi({
    required this.status,
    required this.errorCode,
     this.error,
    required this.data,
  });
  late final String status;
  late final String errorCode;
  late final Null error;
  late final Data data;
  
  TokenApi.fromJson(Map<String, dynamic> json){
    status = json['status'];
    errorCode = json['errorCode'];
    error = null;
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['errorCode'] = errorCode;
    _data['error'] = error;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.token,
  });
  late final String token;
  
  Data.fromJson(Map<String, dynamic> json){
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    return _data;
  }
}