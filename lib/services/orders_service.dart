import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/order.dart';

class OrdersService with ChangeNotifier {
  String nodeName = 'orders';
  FirebaseDatabase database = FirebaseDatabase.instance;
  Order order;

  OrdersService({this.order});

  Future<void> setOrderIsProcessed(bool status) async {
    await database.reference().child('$nodeName/${order.id}').update({
      'isProcessed': status,
    });
  }

  Future<void> setOrderIsBeingPrepared(bool status) async {
    await database.reference().child('$nodeName/${order.id}').update({
      'isBeingPrepared': status,
    });
  }

  Future<void> setOrderIsOnTheWay(bool status) async {
    await database.reference().child('$nodeName/${order.id}').update({
      'isOnTheWay': status,
    });
  }
}
