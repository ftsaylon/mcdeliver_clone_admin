import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: _deviceSize.height,
        width: _deviceSize.width,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Image.asset('assets/images/logo/simple_logo.png'),
        ),
      ),
    );
  }
}
