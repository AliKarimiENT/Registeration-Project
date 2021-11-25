import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_project/constants/enum.dart';
import 'package:register_project/models/api/validators/email_validation_api.dart';
import 'package:register_project/models/api/validators/username_validation_api.dart';
import 'package:register_project/models/email.dart';
import 'package:register_project/models/full_name.dart';
import 'package:register_project/models/api/token_api.dart';
import 'package:register_project/models/username.dart';
import 'package:register_project/repository/api_repository.dart';

part 'register_form_event.dart';
part 'register_form_state.dart';

class RegisterFormBloc extends Bloc<RegisterFormEvent, RegisterFormState> {
  final ApiRepository repository = ApiRepository();
  final _picker = ImagePicker();
  
  File? image;
  RegisterFormBloc()
      : super(RegisterFormState(
          avatarPath: '',
          token: '',
          emailValidationType: EmailValidationType.none,
          userNameValidationType: UserNameValidationType.none,
        )) {
    on<RegisterFormEvent>((event, emit) async {
      if (event is GetToken) {
        // print('get token ======');
        try {
          TokenApi token = await repository.fetchToken();
          // print('================== token is ${token.data.token.toString()}');
          emit(state.copyWith(
              token: token.data.token.toString(),
              imageSourceActionSheetIsVisible: false,
              status: Formz.validate(
                  [state.fullName, state.email, state.userName])));
        } catch (e) {
          throw e.toString();
        }
      } else if (event is UsernameChanged) {
        final username = UserName.dirty(event.username);
        UsernameValidationApi usernameValidation =
            await repository.validateUsername(event.username);
        print(
            'username validation is ::::: ${usernameValidation.validate.toString()}');
        // var validationType = UserNameValidationType.none;
        UserNameValidationType? validationType;
        if (usernameValidation.validate.toString() == "valid") {
          validationType = UserNameValidationType.valid;
        } else if (usernameValidation.validate.toString() == "warrning") {
          validationType = UserNameValidationType.warrning;
        } else if (usernameValidation.validate.toString() == "exists ") {
          validationType = UserNameValidationType.exists;
        }

        emit(
          state.copyWith(
              userName:
                  username.valid ? username : UserName.pure(event.username),
              imageSourceActionSheetIsVisible: false,
              status: Formz.validate([username, state.email, state.fullName]),
              userNameValidationType: validationType),
        );
      } else if (event is EmailChanged) {
        final email = Email.dirty(event.email);
        EmailValidationApi emailValidation =
            await repository.validateEmail(event.email);
        print(
            'email validation is ::::: ${emailValidation.validate.toString()}');
        var validationType = EmailValidationType.none;
        switch (emailValidation.validate.toString()) {
          case 'valid':
            validationType = EmailValidationType.valid;
            break;
          case 'invalid':
            validationType = EmailValidationType.invalid;
            break;
        }
        emit(
          state.copyWith(
              email: email.valid ? email : Email.pure(event.email),
              imageSourceActionSheetIsVisible: false,
              status: Formz.validate([email, state.fullName, state.userName]),
              emailValidationType: validationType),
        );
      } else if (event is FullNameChanged) {
        final name = FullName.dirty(event.name);
        emit(state.copyWith(
            fullName: name.valid ? name : FullName.pure(event.name),
            imageSourceActionSheetIsVisible: false,
            status: Formz.validate([name, state.email, state.userName])));
      } else if (event is UsernameUnfocused) {
        final username = UserName.dirty(state.userName.value);
        emit(state.copyWith(
            userName: username,
            imageSourceActionSheetIsVisible: false,
            status: Formz.validate([state.fullName, state.email])));
      } else if (event is FullNameUnfocused) {
        final name = FullName.dirty(state.fullName.value);
        emit(state.copyWith(
            fullName: name,
            imageSourceActionSheetIsVisible: false,
            status: Formz.validate([state.userName, state.email])));
      } else if (event is EmailUnfocused) {
        final email = Email.dirty(state.email.value);
        emit(state.copyWith(
            email: email,
            imageSourceActionSheetIsVisible: false,
            status: Formz.validate([state.userName, state.fullName])));
      } else if (event is FormSubmitted) {
        final email = Email.dirty(state.email.value);
        final username = UserName.dirty(state.userName.value);
        final fullname = FullName.dirty(state.fullName.value);
        emit(state.copyWith(
            email: email,
            fullName: fullname,
            userName: username,
            status: Formz.validate([username, email, fullname])));
        if (state.status.isValidated) {
          emit(state.copyWith(
            status: FormzStatus.submissionInProgress,
          ));
          await Future.delayed(const Duration(seconds: 1));
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
          ));
        }
      } else if (event is ChangeAvatarRequest) {
        emit(state.copyWith(imageSourceActionSheetIsVisible: true));
        print(
            'actionSheet is visibility ------ ${state.imageSourceActionSheetIsVisible}');
      } else if (event is OpenImagePicker) {
        try {
          final _pickedImage =
              await _picker.pickImage(source: event.imageSource);
          if (_pickedImage == null) return;
          image = File(_pickedImage.path);
          emit(state.copyWith(
              avatarPath: _pickedImage.path,
              imageSourceActionSheetIsVisible: false));
          print(
              '=== action sheet visibility in Open Image Picker ${state.imageSourceActionSheetIsVisible}');
          // emit(ImagePicked(path: _pickedImage.path));
        } on PlatformException catch (e) {
          print('Failed to pick $e');
        }
      } else if (event is ProvideImagePath) {
      } else if (event is UpdloadData) {
        print('current event is ${event.toString()}');
        repository.sendData(event);
      }
    });

    @override
    onTransition(Transition<RegisterFormEvent, RegisterFormState> transition) {
      print(transition);
      super.onTransition(transition);
    }
  }
}
