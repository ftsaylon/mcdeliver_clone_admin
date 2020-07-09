import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/done_orders_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/orders_screen.dart';

class MainScreen extends StatefulWidget {
  final initialIndex;

  MainScreen({
    Key key,
    this.initialIndex,
  }) : super(key: key);

  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex;

  List<Widget> _widgetOptions = <Widget>[
    MenuScreen(),
    OrdersScreen(),
    DoneOrdersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      title: Text('Menu'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      title: Text('Orders'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_turned_in),
      title: Text('Done Orders'),
    ),
  ];

  @override
  void initState() {
    _selectedIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/logo/simple_logo.png',
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            Text('McDelivery'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
