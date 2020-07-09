import 'package:firebase_database/firebase_database.dart';

import 'cart_item.dart';

class Order {
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

  factory Order.fromSnapshot(DataSnapshot snapshot) {
    return Order(
      id: snapshot.key,
      amount: snapshot.value['amount'],
      products: (snapshot.value['products'] as List<dynamic>)
          .map(
            (item) => CartItem(
              id: item['id'],
              productId: item['productId'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
              imageUrl: item['imageUrl'],
            ),
          )
          .toList(),
      dateCreated: DateTime.parse(snapshot.value['dateCreated']),
      address: snapshot.value['address'],
      customerName: snapshot.value['customerName'],
      remarks: snapshot.value['remarks'],
      changeFor: snapshot.value['changeFor'],
      isSubmitted: snapshot.value['isSubmitted'],
      isProcessed: snapshot.value['isProcessed'],
      isBeingPrepared: snapshot.value['isBeingPrepared'],
      isOnTheWay: snapshot.value['isOnTheWay'],
    );
  }

  Map toMap() {
    return {
      'amount': amount,
      'products': products,
      'dateCreated': dateCreated,
      'address': address,
      'customerName': customerName,
      'remarks': remarks,
      'changeFor': changeFor,
      'isSubmitted': isSubmitted,
      'isProcessed': isProcessed,
      'isBeingPrepared': isBeingPrepared,
      'isOnTheWay': isOnTheWay,
    };
  }
}
