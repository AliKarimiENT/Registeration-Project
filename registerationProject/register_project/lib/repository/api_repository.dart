import 'package:register_project/bloc/register/register_form_bloc.dart';
import 'package:register_project/models/api/token_api.dart';
import 'package:register_project/models/api/validators/email_validation_api.dart';
import 'package:register_project/models/api/validators/username_validation_api.dart';
import 'package:register_project/network_manager.dart';

class ApiRepository {
  NetworkManager networkManager = NetworkManager();
  Future<TokenApi> fetchToken() => networkManager.getToken();
  void sendData(UpdloadData event) => networkManager.sendData(event);
  Future<EmailValidationApi> validateEmail(String email) =>
      networkManager.validateEmail(email);
  Future<UsernameValidationApi> validateUsername(String username) =>
      networkManager.validateUsername(username);
}
