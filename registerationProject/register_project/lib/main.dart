import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_project/cubit/internet_cubit.dart';
import 'package:register_project/pages/disconnected_page.dart';
import 'package:register_project/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registeration Project',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => InternetCubit(connectivity: Connectivity()),
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetConnected) {
              return RegisterPage();
            }
            return DisconnectedPage();
          },
        ),
      ),
    );
  }
}
