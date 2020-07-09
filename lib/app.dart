import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import './screens/main_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'McDelivery Clone Admin',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
