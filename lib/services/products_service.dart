import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsService with ChangeNotifier {
  String nodeName = 'products';
  FirebaseDatabase database = FirebaseDatabase.instance;
  Product product;

  ProductsService({this.product});

  Future<void> addProduct() async {
    await database.reference().child(nodeName).push().set(product.toMap());
  }

  Future<void> deletePost() async {
    await database.reference().child('$nodeName/${product.id}').remove();
  }

  Future<void> updateProduct() async {
    await database.reference().child('$nodeName/${product.id}').update(
      {
        'title': product.title,
        'categoryId': product.categoryId,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      },
    );
  }
}
