import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_project/bloc/register/register_form_bloc.dart';
import 'package:register_project/constants/enum.dart';
import 'package:register_project/pages/user_info.dart';
import 'package:register_project/widgets/success_dialog.dart';

final RegisterFormBloc registerFormBloc = RegisterFormBloc();

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = '';
  String email = '';
  String name = '';
  final formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _fullnameFocusNode = FocusNode();
  var jsonMap = HashMap<String, String>();
  @override
  void initState() {
    super.initState();
    registerFormBloc.add(GetToken());
    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus == false) {
        registerFormBloc.add(UsernameUnfocused());
        FocusScope.of(context).requestFocus(_fullnameFocusNode);
      }
    });
    _fullnameFocusNode.addListener(() {
      if (_fullnameFocusNode.hasFocus == false) {
        registerFormBloc.add(FullNameUnfocused());
        FocusScope.of(context).requestFocus(_emailFocusNode);
      }
    });
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus == false) {
        registerFormBloc.add(EmailUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _fullnameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return registerFormBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Form'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        body: BlocListener<RegisterFormBloc, RegisterFormState>(
          listener: (context, state) {
            print("token is >>>>>> ${state.token}");
            if (state.status.isSubmissionSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              showDialog(
                context: context,
                builder: (_) => SuccessDialog(),
              );
            }
            if (state.status.isSubmissionInProgress) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submitting is in progress')));
            }
            print('-------------------------$state');
            if (state.imageSourceActionSheetIsVisible) {
              _showImageSourceActionSheet(context);
              print('show action sheet -----------------');
            }
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  buildUserHeaderImage(),
                  const SizedBox(height: 20),
                  UserNameInput(focusNode: _usernameFocusNode),
                  const SizedBox(height: 16),
                  NameInput(focusNode: _fullnameFocusNode),
                  const SizedBox(height: 16),
                  EmailInput(
                    focusNode: _emailFocusNode,
                  ),
                  const SizedBox(height: 20),
                  buildSubmitButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserHeaderImage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Stack(
          children: [
            BlocBuilder<RegisterFormBloc, RegisterFormState>(
              builder: (context, state) {
                if (state.avatarPath == '') {
                  return const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  );
                } else {
                  return CircleAvatar(
                    radius: 50,
                    // child: const Icon(Icons.person),
                    backgroundImage:
                        FileImage(File(state.avatarPath.toString())),
                  );
                }
              },
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(50),
            //   child: CachedNetworkImage(
            //     imageUrl:
            //         'https://images.unsplash.com/photo-1566753323558-f4e0952af115?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=721&q=80',
            //     fit: BoxFit.cover,
            //     placeholder: (context, url) => Container(
            //       child: CircularProgressIndicator(
            //         color: Colors.blue[300],
            //       ),
            //       width: 45,
            //       height: 45,
            //       alignment: Alignment.center,
            //     ),
            //     width: 85,
            //     height: 85,
            //   ),
            // ),
            BlocBuilder<RegisterFormBloc, RegisterFormState>(
              builder: (context, state) {
                print('change avatar');
                return Positioned(
                  child: GestureDetector(
                    onTap: () {
                      print('Gesture Detector tapped');
                      context
                          .read<RegisterFormBloc>()
                          .add(ChangeAvatarRequest());
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width: 2, color: Colors.white),
                          color: Colors.blue),
                      child: const Icon(
                        Icons.edit,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  bottom: 0,
                  right: 0,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegisterFormBloc, RegisterFormState>(
        // buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          print('state is valid? --- ${state.status.isValid}');
          return RawMaterialButton(
            onPressed: state.status.isValid
                ? () {
                    final isValid = formKey.currentState!.validate();
                    bool validatedEmail = false;
                    bool validatedUsername = false;
                    if (state.emailValidationType ==
                        EmailValidationType.valid) {
                      validatedEmail = true;
                    }
                    if (state.userNameValidationType ==
                        UserNameValidationType.valid) {
                      validatedUsername = true;
                    }
                    if (state.avatarPath != '') {
                      if (isValid && validatedEmail && validatedUsername) {
                        formKey.currentState!.save();
                        print(state.avatarPath);
                        registerFormBloc.add(UpdloadData(
                            name: state.fullName.value,
                            username: state.userName.value,
                            email: state.email.value,
                            avatarPath: state.avatarPath,
                            token: state.token));
                        final snackBar = SnackBar(
                            content: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Username : ${state.userName.value}'),
                                Text('Name : ${state.fullName.value}'),
                                Text('Email : ${state.email.value}')
                              ],
                            )
                          ],
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfo(),));

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content:
                                Text('You must upload your avatar image')));
                      }
                    }
                  }
                : null,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Register',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3),
              ),
            ),
            fillColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          );
        },
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<RegisterFormBloc>()
          .add(OpenImagePicker(imageSource: imageSource));
    };

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.camera);
                },
                child: const Text('Camera')),
            CupertinoActionSheetAction(
                onPressed: () {
                  selectImageSource(ImageSource.gallery);
                },
                child: const Text('Gallery'))
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Wrap(children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album_rounded),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.gallery);
                },
              ),
            ]),
          );
        },
      );
    }
  }
}

enum UsernameTextState { wrong, warrning, correct }

class UserNameInput extends StatefulWidget {
  const UserNameInput({Key? key, required this.focusNode}) : super(key: key);
  final FocusNode focusNode;

  @override
  State<UserNameInput> createState() => _UserNameInputState();
}

class _UserNameInputState extends State<UserNameInput> {
  Timer? userStoppedTyping;

  @override
  Widget build(BuildContext context) {
    Icon? suffixIcon;
    Color borderColor = Colors.blue;
    String message = "";
    String text = '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegisterFormBloc, RegisterFormState>(
        builder: (context, state) {
          print(
              'username validation type state is ${state.userNameValidationType}');
          switch (state.userNameValidationType) {
            case UserNameValidationType.warrning:
              borderColor = Colors.orange.shade300;
              suffixIcon = Icon(
                Icons.warning_rounded,
                color: Colors.orange.shade300,
              );
              message = 'Username is not valid';
              break;
            case UserNameValidationType.exists:
              borderColor = Colors.red;
              suffixIcon =
                  const Icon(Icons.error_outline_outlined, color: Colors.red);
              message = 'Username already exists';
              break;
            case UserNameValidationType.valid:
              borderColor = Colors.green;
              suffixIcon = const Icon(Icons.check_rounded, color: Colors.green);
              message = 'Username is valid';
              break;
            case UserNameValidationType.none:
              break;
          }

          print(
              'username ${state.userName} is valid ? ${state.userName.valid}');
          return TextFormField(
            // initialValue: state.userN.value,
            decoration: InputDecoration(
              labelText: 'Username',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: borderColor, width: 3, style: BorderStyle.solid),
              ),
              fillColor: state.userName.valid ? Colors.green : Colors.red,
              border: const OutlineInputBorder(),
              helperText: 'A valid username : alikarimi123',
              suffixIcon: Tooltip(
                message: message,
                child: suffixIcon,
                triggerMode: TooltipTriggerMode.tap,
                waitDuration: const Duration(seconds: 2),
                showDuration: const Duration(milliseconds: 0),
              ),
              errorText: state.userName.invalid
                  ? 'Please ensure the username entered is valid'
                  : null,
            ),
            focusNode: widget.focusNode,
            keyboardType: TextInputType.name,
            onChanged: _onChangeHandler,
            // onChanged: (value) {
            //   text = value;
            //   registerFormBloc.add(UsernameChanged(username: value));
            // },
            textInputAction: TextInputAction.next,
          );
        },
      ),
    );
  }

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 200);
    if (userStoppedTyping != null) {
      setState(() {
        userStoppedTyping!.cancel();
      });
    }
    setState(() {
      userStoppedTyping = Timer(duration, () {
        print("user's inserted value is : $value");
        registerFormBloc.add(UsernameChanged(username: value));
      });
    });
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            initialValue: state.fullName.value,
            validator: (value) {
              value == '';
            },
            decoration: InputDecoration(
              labelText: 'Name',
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: Colors.blue, width: 3, style: BorderStyle.solid),
              ),
              helperText: 'Ex: Ali Karimi',
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Colors.red, width: 3, style: BorderStyle.solid)),
              errorText: state.fullName.invalid
                  ? 'Please ensure the name  entered is valid'
                  : null,
            ),
            keyboardType: TextInputType.name,
            focusNode: focusNode,
            onChanged: (value) {
              registerFormBloc.add(FullNameChanged(name: value));
            },
            textInputAction: TextInputAction.next,
            // onSaved: (value) {
            //   setState(() {
            //     name = value!;
            //     print('the name is ');
            //   });
            // },
            // validator: (value) {
            //   if (value!.length < 6) {
            //     return 'Your name must be more than 5 characters';
            //   } else {
            //     return null;
            //   }
            // },
          ),
        );
      },
    );
  }
}

class EmailInput extends StatefulWidget {
  const EmailInput({Key? key, required this.focusNode}) : super(key: key);

  final FocusNode focusNode;

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  Timer? userStoppedTyping;
  late Color borderColor;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterFormBloc, RegisterFormState>(
      builder: (context, state) {
        print(
            'email validation type state is ${state.emailValidationType.toString()}');
        if (state.emailValidationType == EmailValidationType.valid) {
          borderColor = Colors.green;
        } else if (state.emailValidationType == EmailValidationType.invalid) {
          borderColor = Colors.red;
        } else {
          borderColor = Colors.blue;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            initialValue: state.email.value,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: state.email.invalid
                  ? 'Please ensure the name  entered is valid'
                  : null,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor, width: 3)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor)),
              helperText: 'A complete, valid email e.g. joe@gmail.com',
            ),
            focusNode: widget.focusNode,
            keyboardType: TextInputType.emailAddress,
            onChanged: _onChangeHandler,
            textInputAction: TextInputAction.done,
          ),
        );
      },
    );
  }

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 500);
    if (userStoppedTyping != null) {
      setState(() {
        userStoppedTyping!.cancel();
      });
    }
    setState(() {
      userStoppedTyping = Timer(duration, () {
        print("user's inserted value is : $value");
        registerFormBloc.add(EmailChanged(email: value));
      });
    });
  }
}
