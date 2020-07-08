import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/order.dart';

class OrdersService with ChangeNotifier {
  String nodeName = 'orders';
  FirebaseDatabase database = FirebaseDatabase.instance;
  Order order;

  OrdersService({this.order});

  setOrderIsProcessed(bool status) {
    database.reference().child('$nodeName/${order.id}').update({
      'isProcessed': status,
    });
  }

  setOrderIsBeingPrepared(bool status) {
    database.reference().child('$nodeName/${order.id}').update({
      'isBeingPrepared': status,
    });
  }

  setOrderIsOnTheWay(bool status) {
    database.reference().child('$nodeName/${order.id}').update({
      'isOnTheWay': status,
    });
  }
}
