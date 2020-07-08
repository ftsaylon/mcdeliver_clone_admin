import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsService with ChangeNotifier {
  String nodeName = 'products';
  FirebaseDatabase database = FirebaseDatabase.instance;
  Product product;

  ProductsService({this.product});

  addProduct() {
    database.reference().child(nodeName).push().set(product.toMap());
  }

  deletePost() {
    database.reference().child('$nodeName/${product.id}').remove();
  }

  updateProduct() {
    database.reference().child('$nodeName/${product.id}').update(
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
