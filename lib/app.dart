import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/providers/auth.dart';
import 'package:mcdelivery_clone_admin/screens/auth_screen.dart';
import 'package:mcdelivery_clone_admin/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'McDelivery Clone Admin',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.yellow,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
        ),
      ),
    );
  }
}
