part of 'register_form_bloc.dart';

// class RegisterFormState extends Equatable {
//   UserName? userName;
//   Email? email;
//   FullName? fullName;
//   bool? imageSourceActionSheetIsVisible;
//   String? avatarPath;
//   String? token;
//   RegisterFormState({
//      this.userName,
//      this.email,
//      this.fullName,
//      this.imageSourceActionSheetIsVisible,
//      this.avatarPath,
//      this.token,
//   });
//   RegisterFormState copyWith(
//       {Email? email,
//       UserName? userName,
//       FullName? fullName,
//       bool? imageSourceActionSheetIsVisible,
//       String? avatarPath,
//       String? token}) {
//     var registerFormState = RegisterFormState(
//         email: email ?? this.email,
//         userName: userName ?? this.userName,
//         fullName: fullName ?? this.fullName,
//         imageSourceActionSheetIsVisible: imageSourceActionSheetIsVisible ??
//             this.imageSourceActionSheetIsVisible,
//         avatarPath: avatarPath ?? this.avatarPath,
//         token: token ?? this.token);
//     return registerFormState;
//   }

//   @override
//   List<Object?> get props => [
//         userName,
//         email,
//         fullName,
//         avatarPath,
//         imageSourceActionSheetIsVisible,
//         token
//       ];
// }

class RegisterFormState extends Equatable {
  final UserName userName;
  final Email email;
  final FullName fullName;
  final FormzStatus status;
  bool imageSourceActionSheetIsVisible;
  String avatarPath;
  String token;
  UserNameValidationType userNameValidationType;
  EmailValidationType emailValidationType;
  RegisterFormState(
      {this.userName = const UserName.pure(),
      this.email = const Email.pure(),
      this.fullName = const FullName.pure(),
      this.status = FormzStatus.pure,
      this.imageSourceActionSheetIsVisible = false,
      required this.avatarPath,
      required this.token,
      required this.userNameValidationType,
      required this.emailValidationType});

  RegisterFormState copyWith(
      {Email? email,
      UserName? userName,
      FullName? fullName,
      FormzStatus? status,
      bool? imageSourceActionSheetIsVisible,
      String? avatarPath,
      String? token,
      UserNameValidationType? userNameValidationType,
      EmailValidationType? emailValidationType}) {
    var registerFormState = RegisterFormState(
        email: email ?? this.email,
        userName: userName ?? this.userName,
        fullName: fullName ?? this.fullName,
        status: status ?? this.status,
        imageSourceActionSheetIsVisible: imageSourceActionSheetIsVisible ??
            this.imageSourceActionSheetIsVisible,
        avatarPath: avatarPath ?? this.avatarPath,
        token: token ?? this.token,
        emailValidationType: emailValidationType ?? this.emailValidationType,
        userNameValidationType: userNameValidationType ?? this.userNameValidationType);
    return registerFormState;
  }

  @override
  List<Object> get props => [
        userName,
        email,
        fullName,
        status,
        avatarPath,
        imageSourceActionSheetIsVisible,
        token,
        userNameValidationType,
        emailValidationType
      ];
}

// class ImagePicked extends RegisterFormState {
//  final String path;

//   ImagePicked({required this.path,});
//   @override
//   List<Object> get props => [path];
// }
