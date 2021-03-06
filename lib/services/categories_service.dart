import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/category.dart';

class CategoriesService with ChangeNotifier {
  String nodeName = 'categories';
  FirebaseDatabase database = FirebaseDatabase.instance;
  Category category;

  CategoriesService({this.category});

  Future<void> addCategory() async {
    await database.reference().child(nodeName).push().set(category.toMap());
  }

  Future<void> updateCategory() async {
    await database.reference().child('$nodeName/${category.id}').update(
      {
        'title': category.title,
      },
    );
  }

  Future<void> deleteCategory() async {
    await database.reference().child('$nodeName/${category.id}').remove();

    database
        .reference()
        .child('products')
        .orderByChild('categoryId')
        .equalTo(category.id)
        .once()
        .then(
      (snapshot) {
        database.reference().child('products/${snapshot.key}').remove();
      },
    );
  }
}
