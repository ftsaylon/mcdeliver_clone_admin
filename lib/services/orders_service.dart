import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';

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
