import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/screens/done_orders_screen.dart';
import 'package:mcdelivery_clone_admin/screens/orders_screen.dart';
import 'package:mcdelivery_clone_admin/screens/products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Hi, Admin!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text('Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                ProductsScreen.routeName,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                OrdersScreen.routeName,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_turned_in),
            title: Text('Finished Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                DoneOrdersScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
