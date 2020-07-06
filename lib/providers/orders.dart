import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';

import 'order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  String authToken;
  String userId;

  Orders(this.authToken, this.userId, this._items);

  List<Order> get items {
    _items.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    return [..._items];
  }

  Order findById(String id) {
    return _items.firstWhere((order) => order.id == id);
  }

  Future<void> fetchAndSetOrders() async {
    final filterString = 'orderBy="creatorId"&equalTo="$userId"';
    var url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/orders.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Order> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.insert(
          0,
          Order(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
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
            customerName: orderData['customerName'],
            address: orderData['address'],
            remarks: orderData['remarks'],
            changeFor: orderData['changeFor'],
            dateCreated: DateTime.parse(orderData['dateCreated']),
            isSubmitted: orderData['isSubmitted'],
            isProcessed: orderData['isProcessed'],
            isBeingPrepared: orderData['isBeingPrepared'],
            isOnTheWay: orderData['isOnTheWay'],
          ),
        );
      });
      _items = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<String> addOrder(
    List<CartItem> cartProducts,
    double amount,
    String customerName,
    String address,
    String remarks,
    double changeFor,
  ) async {
    final url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/orders.json?auth=$authToken';

    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': amount,
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'productId': cartProduct.productId,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                    'imageUrl': cartProduct.imageUrl,
                  })
              .toList(),
          'customerName': customerName,
          'address': address,
          'remarks': remarks,
          'changeFor': changeFor,
          'dateCreated': timestamp.toIso8601String(),
          'isSubmitted': true,
          'isProcessed': false,
          'isBeingPrepared': false,
          'isOnTheWay': false,
          'creatorId': userId,
        }),
      );

      final newOrder = Order(
        id: json.decode(response.body)['name'],
        amount: amount,
        products: cartProducts,
        dateCreated: timestamp,
        customerName: customerName,
        address: address,
        remarks: remarks,
        changeFor: changeFor,
        isSubmitted: true,
      );

      _items.add(newOrder);
      notifyListeners();
      return newOrder.id;
    } catch (error) {
      throw (error);
    }
  }
}
