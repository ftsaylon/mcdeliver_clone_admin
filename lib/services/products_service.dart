import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsService with ChangeNotifier {
  String nodeName = 'products';
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  Product product;

  ProductsService({this.product});

  Future<void> addProduct() async {
    print('adding...');
    await database.reference().child(nodeName).push().set(product.toMap());
  }

  Future<void> deleteProduct() async {
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
