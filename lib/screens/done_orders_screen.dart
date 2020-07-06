import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/order.dart';
import 'package:mcdelivery_clone_admin/services/orders_service.dart';
import 'package:mcdelivery_clone_admin/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class DoneOrdersScreen extends StatefulWidget {
  static const routeName = '/done-orders';
  DoneOrdersScreen({Key key}) : super(key: key);

  @override
  _DoneOrdersScreenState createState() => _DoneOrdersScreenState();
}

class _DoneOrdersScreenState extends State<DoneOrdersScreen> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = 'orders';
  List<Order> ordersList = <Order>[];

  @override
  void initState() {
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoves);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'FINISHED ORDERS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
            visible: ordersList.isNotEmpty,
            child: Expanded(
              child: FirebaseAnimatedList(
                query: _database.reference().child('orders'),
                itemBuilder: (context, snapshot, animation, index) {
                  final order = ordersList[index];
                  return Visibility(
                    visible: order.isOnTheWay,
                    child: OrderListItem(
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

  _childAdded(Event event) {
    setState(() {
      ordersList.add(Order.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedorder = ordersList.singleWhere((order) {
      return order.id == event.snapshot.key;
    });

    setState(() {
      ordersList.removeAt(ordersList.indexOf(deletedorder));
    });
  }

  void _childChanged(Event event) {
    var changedorder = ordersList.singleWhere((order) {
      return order.id == event.snapshot.key;
    });

    setState(() {
      ordersList[ordersList.indexOf(changedorder)] =
          Order.fromSnapshot(event.snapshot);
    });
  }
}
