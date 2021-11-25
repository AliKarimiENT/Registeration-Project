import 'dart:convert';

import 'package:register_project/models/api/token_api.dart';
import 'package:http/http.dart' as http;
import 'package:register_project/models/api/validators/email_validation_api.dart';
import 'package:register_project/models/api/validators/username_validation_api.dart';

import 'bloc/register/register_form_bloc.dart';

class NetworkManager {
  static const String BASE_URL = "app.shopalls.ir";
  static const String GET_TOKEN_URL = "/api/gettoken";
  static const String POST_USER = '/api/insert';
  static const String GET_USER = '/api/users';
  static const String EMAIL_VALIDAITON = '/api/vaildateemail';
  static const String USERNAME_VALIDAITON = '/api/vaildateusername';

  Future<TokenApi> getToken() async {
    var url = Uri.https(BASE_URL, GET_TOKEN_URL);
    http.Response response = await http.get(url);
    print('-------------- ${response.body}');
    var tokenData = json.decode(response.body);
    TokenApi data = TokenApi.fromJson(tokenData);
    return data;
  }

  void sendData(UpdloadData event) async {
    var url = Uri.https(BASE_URL, POST_USER);
    var request = http.MultipartRequest('POST', url);

    request.headers['name'] = event.name;
    request.headers['username'] = event.username;
    request.headers['email'] = event.email;
    request.headers['token'] = event.token;
    request.files
        .add(await http.MultipartFile.fromPath('image', event.avatarPath));
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    var responseBody = await http.Response.fromStream(response);
    print(responseBody.body);
    print(response.request);
  
  }

  Future<EmailValidationApi> validateEmail(String email) async {
    final queryParameters = {'email': email};
    var url = Uri.https(BASE_URL, EMAIL_VALIDAITON, queryParameters);
    http.Response response = await http.post(url);
    print('-------------- ${response.body}');
    var validationData = json.decode(response.body);
    EmailValidationApi data = EmailValidationApi.fromJson(validationData);
    return data;
  }

  Future<UsernameValidationApi> validateUsername(String username) async {
    final queryParameters = {'username': username};
    var url = Uri.https(BASE_URL, USERNAME_VALIDAITON, queryParameters);
    http.Response response = await http.post(url);
    print('-------------- ${response.body}');
    var validationData = json.decode(response.body);
    UsernameValidationApi data = UsernameValidationApi.fromJson(validationData);
    return data;
  }
}
