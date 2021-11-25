import 'package:formz/formz.dart';

enum EmailValidationError { empty }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String value = '']) : super.pure(value);
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    return value!.isEmpty ? EmailValidationError.empty : null;
  }
}
