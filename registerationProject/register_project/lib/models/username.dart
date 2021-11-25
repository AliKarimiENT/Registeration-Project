import 'package:formz/formz.dart';
import 'package:register_project/constants/enum.dart';

class UserName extends FormzInput<String, UserNameValidationError> {
  // Call super.pure to represent an unmodified form input.
  const UserName.pure([String value = '']) : super.pure(value);

  // Call super.dirty to represent a modified form input.
  const UserName.dirty([String value = '']) : super.dirty(value);

  static final usernameRegex = RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$");

  @override
  UserNameValidationError? validator(String? value) {
    return value!.isEmpty ? UserNameValidationError.empty : null;
  }
}

enum UserNameValidationError { empty}
