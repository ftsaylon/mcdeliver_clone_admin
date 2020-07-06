import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Order with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateCreated;
  final String address;
  final String customerName;
  final String remarks;
  final double changeFor;
  bool isSubmitted;
  bool isProcessed;
  bool isBeingPrepared;
  bool isOnTheWay;

  Order({
    this.id,
    this.amount,
    this.products,
    this.dateCreated,
    this.address,
    this.customerName,
    this.remarks,
    this.changeFor,
    this.isSubmitted,
    this.isProcessed = false,
    this.isBeingPrepared = false,
    this.isOnTheWay = false,
  });
}
