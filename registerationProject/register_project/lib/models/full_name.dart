import 'package:formz/formz.dart';

class FullName extends FormzInput<String, FullNameError> {
  const FullName.pure([String value = '']) : super.pure(value);
  const FullName.dirty([String value = '']) : super.dirty(value);
  @override
  validator(value) {
        return value.isEmpty ? FullNameError.empty : null;

    // if (value == '') {
    //   return FullNameError.invalid;
    // }
  }
}

enum FullNameError { empty }
