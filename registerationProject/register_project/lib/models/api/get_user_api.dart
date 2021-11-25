class GetUserApi {
  GetUserApi({
    required this.status,
    required this.errorCode,
     this.error,
    required this.data,
  });
  late final String status;
  late final String errorCode;
  late final Null error;
  late final Data data;
  
  GetUserApi.fromJson(Map<String, dynamic> json){
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
    required this.userinfo,
  });
  late final List<Userinfo> userinfo;
  
  Data.fromJson(Map<String, dynamic> json){
    userinfo = List.from(json['userinfo']).map((e)=>Userinfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userinfo'] = userinfo.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Userinfo {
  Userinfo({
    required this.name,
    required this.image,
    required this.username,
    required this.email,
  });
  late final String name;
  late final String image;
  late final String username;
  late final String email;
  
  Userinfo.fromJson(Map<String, dynamic> json){
    name = json['name'];
    image = json['image'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['image'] = image;
    _data['username'] = username;
    _data['email'] = email;
    return _data;
  }
}