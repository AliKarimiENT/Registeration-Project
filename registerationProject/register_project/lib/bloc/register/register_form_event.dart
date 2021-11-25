part of 'register_form_bloc.dart';

abstract class RegisterFormEvent extends Equatable {
  const RegisterFormEvent();

  @override
  List<Object?> get props => [];
}

class GetToken extends RegisterFormEvent {
  @override
  List<Object?> get props => [];
}

class EmailChanged extends RegisterFormEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class EmailUnfocused extends RegisterFormEvent {}

class UsernameChanged extends RegisterFormEvent {
  final String username;
  const UsernameChanged({
    required this.username,
  });

  @override
  List<Object?> get props => [username];
}

class UsernameUnfocused extends RegisterFormEvent {}

class FullNameChanged extends RegisterFormEvent {
  final String name;
  const FullNameChanged({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}

class FullNameUnfocused extends RegisterFormEvent {}

class FormSubmitted extends RegisterFormEvent {}

// image picker events . . . .

class ChangeAvatarRequest extends RegisterFormEvent {
  @override
  List<Object?> get props => [];
}

class OpenImagePicker extends RegisterFormEvent {
  final ImageSource imageSource;

  const OpenImagePicker({required this.imageSource});

  @override
  List<Object?> get props => [imageSource];
}

class ProvideImagePath extends RegisterFormEvent {
  final String avatarPath;

  const ProvideImagePath({required this.avatarPath});
  @override
  List<Object?> get props => [avatarPath];
}

class UpdloadData extends RegisterFormEvent {
  final String username, name, email, avatarPath,token;

  const UpdloadData({required this.username, required this.name, required this.email, required this.avatarPath,required this.token});
  @override
  List<Object?> get props => [username,name,email,avatarPath,token];
}
