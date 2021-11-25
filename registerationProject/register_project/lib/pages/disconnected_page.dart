import 'package:flutter/material.dart';

class DisconnectedPage extends StatelessWidget {
  const DisconnectedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('Your device is disconnected to network'),
          ),
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
