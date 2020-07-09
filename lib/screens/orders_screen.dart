import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../models/order.dart';

import '../widgets/order_list_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = 'orders';
  List<Order> ordersList = <Order>[];

  StreamSubscription<Event> _onChildAdded;
  StreamSubscription<Event> _onChildRemoved;
  StreamSubscription<Event> _onChildChanged;

  @override
  void initState() {
    _onChildAdded =
        _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _onChildRemoved = _database
        .reference()
        .child(nodeName)
        .onChildRemoved
        .listen(_childRemoves);
    _onChildChanged = _database
        .reference()
        .child(nodeName)
        .onChildChanged
        .listen(_childChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onChildAdded.cancel();
    _onChildRemoved.cancel();
    _onChildChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'ORDERS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
            replacement: Center(
              child: Text(
                'You Have No Pending Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            visible: ordersList.isNotEmpty,
            child: Expanded(
              child: FirebaseAnimatedList(
                query: _database
                    .reference()
                    .child('orders')
                    .orderByChild('isOnTheWay')
                    .equalTo(false),
                itemBuilder: (context, snapshot, animation, index) {
                  final order = ordersList[index];
                  return Visibility(
                    visible: !order.isOnTheWay,
                    child: OrderListItem(
                      key: UniqueKey(),
                      order: order,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _childAdded(Event event) {
    final newOrder = Order.fromSnapshot(event.snapshot);
    setState(() {
      ordersList.insert(0, newOrder);
    });
  }

  void _childRemoves(Event event) {
    final deletedOrder = ordersList.singleWhere((order) {
      return order.id == event.snapshot.key;
    });

    setState(() {
      ordersList.removeAt(ordersList.indexOf(deletedOrder));
    });
  }

  void _childChanged(Event event) {
    final changedOrder = ordersList.singleWhere((order) {
      return order.id == event.snapshot.key;
    });

    setState(() {
      ordersList[ordersList.indexOf(changedOrder)] =
          Order.fromSnapshot(event.snapshot);
    });
  }
}
