import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/screens/auth_screen.dart';
import 'package:mcdelivery_clone_admin/screens/done_orders_screen.dart';
import 'package:mcdelivery_clone_admin/screens/main_screen.dart';
import 'package:mcdelivery_clone_admin/screens/orders_screen.dart';
import 'package:mcdelivery_clone_admin/screens/products_screen.dart';

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
            return OrdersScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        MainScreen.routeName: (context) => MainScreen(),
        OrdersScreen.routeName: (context) => OrdersScreen(),
        DoneOrdersScreen.routeName: (context) => DoneOrdersScreen(),
        ProductsScreen.routeName: (context) => ProductsScreen(),
      },
    );
  }
}
